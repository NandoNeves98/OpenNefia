local AspectHolder = require("api.AspectHolder")
local IAspect = require("api.IAspect")
local Aspect = require("api.Aspect")
local IAspectModdable = require("api.IAspectModdable")
local Log = require("api.Log")

local IAspectHolder = class.interface("IAspectHolder")

function IAspectHolder:init()
   self._aspects = AspectHolder:new()
end

local function is_aspect(v)
   return class.is_interface(v) and class.is_an(IAspect, v)
end

local function default_aspect(obj, iface, params)
   local klass
   if params._impl then
      class.assert_implements(iface, params._impl)
      klass = params._impl
      params._impl = nil
   else
      klass = Aspect.get_default_impl(iface)
   end
   Log.trace("Default iface for aspect %s: %s", iface, klass)
   local aspect = klass:new(obj, params)
   IAspectModdable.init(aspect)
   obj:set_aspect(iface, aspect)
end

function IAspectHolder:normal_build(params)
   local params = params and params.aspects
   local seen = table.set {}
   local _ext = self.proto._ext
   if _ext then
      for k, v in pairs(_ext) do
         if type(k) == "number" and is_aspect(v) then
            seen[v] = true
            default_aspect(self, v, (params and params[v]) or {})
         elseif is_aspect(k) then
            seen[k] = true
            local _params = (params and params[k]) or {}
            if type(v) == "table" then
               _params = table.merge_ex(table.deepcopy(v), _params)

               -- HACK it shouldn't be possible to deepcopy class tables
               if v._impl then
                  _params._impl = v._impl
               end
            end
            default_aspect(self, k, _params)
         end
      end
   end

   if params then
      for k, v in pairs(params) do
         if is_aspect(k) and not seen[k] then
            Log.error("Aspect arguments recieved for %s, but prototype '%s:%s' does not declare that aspect in its _ext table.", k, self._type, self._id)
         end
      end
   end
end

function IAspectHolder:on_refresh()
   for _, aspect in self:iter_aspects() do
      aspect:on_refresh()
   end
end

function IAspectHolder:get_aspect(iface)
   return self._aspects:get_aspect(self, iface)
end

function IAspectHolder:get_aspect_or_default(iface, and_set, ...)
   return self._aspects:get_aspect_or_default(self, iface, and_set, ...)
end

function IAspectHolder:set_aspect(iface, aspect)
   self._aspects:set_aspect(self, iface, aspect)
end

function IAspectHolder:get_aspect_proto(iface)
   local _ext = self.proto._ext
   if not _ext then
      return nil
   end
   if _ext[iface] then
      return _ext[iface]
   end

   -- iterate list part of table
   for _, item in ipairs(_ext) do
      if item == iface then
         return {}
      end
   end

   return nil
end

function IAspectHolder:iter_aspects(iface)
   if iface then
      return self:iter_aspects():filter(function(a) return class.is_an(iface, a) end)
   end

   return fun.wrap(self._aspects:iter())
end

function IAspectHolder:calc_aspect(iface, prop)
   local aspect = self:get_aspect(iface)
   if aspect == nil then
      return nil
   end
   return aspect:calc(self, prop)
end

function IAspectHolder:calc_aspect_base(iface, prop)
   local aspect = self:get_aspect(iface)
   if aspect == nil then
      return nil
   end
   return aspect:calc(self, prop, true)
end

function IAspectHolder:mod_aspect(iface, prop, v, method, params)
   local aspect = self:get_aspect(iface)
   if aspect == nil then
      error("Aspect is nil")
   end
   return aspect:mod(self, prop, v, method, params)
end

function IAspectHolder:mod_aspect_base(iface, prop, v, method, params)
   local aspect = self:get_aspect(iface)
   if aspect == nil then
      error("Aspect is nil")
   end
   return aspect:mod_base(self, prop, v, method, params)
end

return IAspectHolder
