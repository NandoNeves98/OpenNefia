local Log = require("api.Log")
local Doc = require("api.Doc")
local ReplCompletion = require("api.gui.menu.ReplCompletion")
local ReplLayer = require("api.gui.menu.ReplLayer")
local doc = require("internal.doc")
local doc_store = require("internal.global.doc_store")
local fs = require("util.fs")
local hotload = require("internal.hotload")
local socket = require("socket")
local json = require("thirdparty.json")
local field = require("game.field")
local i18n = require("internal.i18n.init")

local commands = {}

local function error_result(err)
   return {
      success = false,
      message = err
   }
end

-- Request:
--
-- {
--   "command": "run",
--   "args": { "code": "tostring(42)" }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "result": "42"
-- }
function commands.run(args)
   local continue, status, success, result
   local dt = 0

   local fn, err = loadstring(args.code)

   if fn then
      -- NOTE: It is very important that the code being run does not
      -- call coroutine.yield, or it will mess up the flow and
      -- potentially leave the debug server in an invalid state. To
      -- protect against this, run the code itself in a new coroutine
      -- so if the code yields it will not affect any state.
      local coro = coroutine.create(function() return xpcall(fn, function(e) return e .. "\n" .. debug.traceback(2) end) end)
      repeat
         continue, success, result = coroutine.resume(coro, dt, nil)
         dt = coroutine.yield()
      until not continue or coroutine.status(coro) == "dead"

      if continue then
         success = true
         Log.info("Success: %s", result)
         status = "success"
      else
         Log.error("Exec error:\n\t%s", result)
         status = "exec_error"
      end
   else
      Log.error("Compile error:\n\t%s", err)
      status = "compile_error"
   end

   if not success then
      return error_result(status)
   end

   return { success = true, result = ReplLayer.format_repl_result(result) }
end

-- Request:
--
-- {
--   "command": "hotload",
--   "args": { "require_path": "api.Rand" }
-- }
--
-- Response:
--
-- {
--   "success":true
-- }
function commands.hotload(args)
   local success, status = xpcall(hotload.hotload, debug.traceback, args.require_path)

   if not success then
      return error_result(status)
   end

   return {}
end

local function with_candidates(cb)
   return function(args)
      local result, err = Doc.get(args.query)

      if result then
         if result.entry then
            return cb(result.entry, args)
         else
            return { candidates = result.candidates }
         end
      end

      return { message = err }
   end
end

-- Request:
--
-- {
--   "command": "help",
--   "args": { "query": "Rand.rnd" }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "doc": "Rand.rnd() is a function defined in <...>"
-- }
--
-- @function commands.help
commands.help = with_candidates(
   function(_, args)
      return { doc = Doc.help(args.query) }
end)

-- Request:
--
-- {
--   "command": "jump_to",
--   "args": { "query": "Rand.rnd" }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "file": "api/Rand.lua",
--   "line":7,
--   "column":0
-- }
--
-- @function commands.jump_to
commands.jump_to = with_candidates(
   function(entry)
      return {
         file = entry.file.filename,
         line = entry.lineno,
         column = 0
      }
   end)

-- Request:
--
-- {
--   "command": "signature",
--   "args": { "query": "Rand.rnd" }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "sig": "Rand.rnd(n)",
--   "params": "(uint) => uint"
--   "summary": "Returns a random integer in `[0, n)`."
-- }
function commands.signature(args)
   local result, err = Doc.get(args.query)

   if not result then
      return {}
   end

   local entry
   if result.candidates then
      for _, pair in ipairs(result.candidates) do
         local full_path = pair[2]
         result, err = Doc.get(full_path)
         if result and result.entry then break end
      end
      if not result or not result.entry then
         return {}
      end
   end

   entry = result.entry

   if not entry.params then
      return {}
   end

   local name = doc.get_item_full_name(entry)

   local sig = string.format("function %s%s end", name, entry.args)

   return {
      sig = sig,
      params = Doc.make_params_string(entry),
      summary = entry.summary
   }
end

-- Request:
--
-- {
--   "command": "template",
--   "args": {
--     "type": "base.chara",
--     "snippet": true,
--     "comments": true,
--     "scope": "template"
--   }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "template": "{ _type = "base.chara", _id = \"\" }"
-- }
function commands.template(args)
   local data = require("internal.data")

   if args.type == "" then
      local types = data:types("template")
      return {
         candidates = fun.iter(types):map(function(t) return {t, t} end):to_list()
      }
   end

   local opts = {
       snippets = args.snippets,
       comments = args.comments,
       scope = args.scope or "template"
   }

   return {
      template = inspect(data:make_template(args.type, opts))
   }
end

-- Request:
--
-- {
--   "command": "ids",
--   "args": { "type": "base.chara" }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "ids":{"elona.putit", ... }
-- }
function commands.ids(args)
   local data = require("internal.data")

   if args.type == "" then
      local types = data:types()
      return {
         candidates = fun.iter(types):map(function(t) return {t, t} end):to_list()
      }
   end

   return {
      ids = data[args.type]:iter():extract("_id"):to_list()
   }
end

-- The size of the apropos candidates list is huge, so transferring it
-- over the network is infeasable. Instead write it to a file and let
-- the user's editor read it from disk.
local apropos_update_time = 0

-- Request:
--
-- {
--   "command": "apropos",
--   "args": {}
-- }
--
-- Response:
--
-- {
--   "success": "undefined"true,
--   "path": "data/apropos.json",
--   "updated": true
-- }
function commands.apropos(args)
   local path = "data/apropos.json"
   local updated = false

   if true or doc.last_updated_time() > apropos_update_time then
      local items = {}

      for full_path, entry in pairs(doc_store.entries) do
         local show = not full_path:match("^private:") and not entry.is_undocumented
         if show then
            for k, item in pairs(entry.items) do
               items[#items+1] = { item.full_path, k }
            end
            items[#items+1] = { entry.full_path, entry.full_path:lower() }
         end
      end

      fs.create_directory(fs.parent(path))
      fs.write(path, json.encode(items))

      apropos_update_time = doc.last_updated_time()
      updated = true
   end

   return {
      path = fs.join(fs.get_save_directory(), path),
      updated = updated
   }
end

-- Request:
--
-- {
--   "command": "completion",
--   "args": { "query": "Chara.cr" }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "results":["Chara.create"]
-- }
function commands.completion(args)
   if not field.repl then
      return {}
   end

   local completion = ReplCompletion:new():complete(args.query, field.repl.env)
   if completion == nil then
      return {}
   end

   -- "candidates" is a special field
   completion.results = completion.candidates
   completion.candidates = nil

   return completion
end

-- Request:
--
-- {
--   "command": "locale_search",
--   "args": { "query": "You need to equip ammos" }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "results":["action.ranged.equip.need_ammo"]
-- }
function commands.locale_search(args)
   local results = fun.iter(i18n.search(args.query))
      :take(100)
      :map(function(r) return { r, i18n.get(r) } end)
      :to_list()
   return {
      results = results
   }
end

-- Request:
--
-- {
--   "command": "locale_key_search",
--   "args": { "query": "yes" }
-- }
--
-- Response:
--
-- {
--   "success":true,
--   "results":["ui.yes"]
-- }
function commands.locale_key_search(args)
   local results = fun.iter(i18n.search_keys(args.query))
      :take(100)
      :map(function(r) return { i18n.get(r), r } end)
      :to_list()
   return {
      results = results
   }
end

local debug_server = class.class("debug_server")

function debug_server:init(port)
   self.port = port or 4567
end

function debug_server:poll()

   local client, _, err = self.server:accept()

   if err and err ~= "timeout" then
      error(err)
   end

   local cmd_name = nil
   local result = nil

   while client ~= nil do
      Log.trace("client recv")

      local text = client:receive("*l")
      Log.debug("Request: %s", text)

      -- JSON should have this format:
      --
      -- {
      --   "command": "help",
      --   "args": { "content": "Chara.create" }
      -- }

      local ok, req = pcall(json.decode, text)
      if not ok then
         result = error_result(req)
      else
         cmd_name = req.command
         local args = req.args or {}
         if type(cmd_name) ~= "string" or type(args) ~= "table" then
            result = error_result("Request must have 'command' string and 'args' table, got: " .. text)
         else
            local cmd = commands[cmd_name]
            if cmd == nil then
               result = error_result("No command named " .. cmd_name)
            else
               local ok, err = xpcall(cmd, debug.traceback, args)
               if not ok then
                  result = error_result(err)
               else
                  result = err
                  result.command = cmd_name
                  if result.success == nil then
                     result.success = true
                  end
               end
            end
         end
      end

      local ok, resp = pcall(json.encode, result)
      if not ok then
         result = error_result("JSON encoding error: " .. resp)
         resp = json.encode(result)
      end

      Log.debug("Response: %s", resp)

      local byte, err = client:send(resp .. "")
      Log.trace("send %s %s", byte, err)
      client:close()

      result = result.success

      client, _, err = self.server:accept()
      if err and err ~= "timeout" then
         error(err)
      end
   end

   return cmd_name, result
end

function debug_server:start()
   if self.server then
      error("Server is already running.")
   end

   local server, err = socket.bind("127.0.0.1", self.port)
   if not server then
      Log.error("!!! Failed to start debug server: %s !!!", err)
      return nil
   end

   self.server = server
   self.server:settimeout(0)
   Log.info("Debug server listening on %d.", self.port)

   local function poll()
      while true do
         local cmd_name, result = self:poll()
         coroutine.yield(cmd_name, result)
      end
   end

   self.coro = coroutine.create(poll)
end

function debug_server:step(dt)
   if self.coro == nil then
      self:stop()
      return
   end

   local ok, err = coroutine.resume(self.coro, dt)
   if not ok then
      Log.error("Error, will stop debug server: %s", debug.traceback(self.coro, err))
      self:stop()
   end
   return ok, err
end

function debug_server:stop()
   if self.server == nil then
      return
   end

   Log.info("Stopping debug server.")

   self.server:close()
   self.server = nil
   self.coro = nil
end

return debug_server
