local fs = require("util.fs")
local mod_info = require("internal.mod_info")
local startup = require("game.startup")
local Event = require("api.Event")
local field = require("game.field")
local env = require("internal.env")
local util = require("tools.cli.util")
local Repl = require("api.Repl")

local function get_chunk(args)
   if args.exec_code then
      return assert(loadstring(args.exec_code))
   elseif args.lua_file == "-" then
      local str = io.stdin:read("*a")
      return assert(loadstring(str))
   else
      local path = fs.to_relative(args.lua_file, args.working_dir)
      return assert(loadfile(path))
   end
end

return function(args)
   local chunk = get_chunk(args)

   if not fs.exists(fs.get_save_directory()) then
      fs.create_directory(fs.get_save_directory())
   end

   local enabled_mods
   if args.load_all_mods then
      enabled_mods = nil
   else
      enabled_mods = { "base", "elona_sys", "elona", "extlibs" }
   end
   local mods = mod_info.scan_mod_dir(enabled_mods)
   startup.run_all(mods)

   Event.trigger("base.on_startup")
   field:init_global_data()

   if args.load_game then
      util.load_game()
   end

   local exec_env
   if args.repl_env then
      exec_env = Repl.generate_env()
      rawset(exec_env, "pass_turn", util.pass_turn)
      rawset(exec_env, "load_game", util.load_game)
   else
      exec_env = env.generate_sandbox("exec")
      rawset(exec_env, "require", env.require)
   end

   setfenv(chunk, exec_env)
   chunk()
end
