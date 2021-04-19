local IItemMusicDisc = require("mod.elona.api.aspect.IItemMusicDisc")
local IItemUseable = require("mod.elona.api.aspect.IItemUseable")
local IItemLocalizableExtra = require("mod.elona.api.aspect.IItemLocalizableExtra")
local Rand = require("api.Rand")
local Gui = require("api.Gui")
local I18N = require("api.I18N")

local ItemMusicDiscAspect = class.class("ItemMusicDiscAspect", { IItemMusicDisc, IItemUseable, IItemLocalizableExtra })

local function can_generate(music)
   return data["base.music"]:ext(music._id, "elona.music_disc").can_randomly_generate
end

function ItemMusicDiscAspect:init(item, params)
   if params.music_id then
      data["base.music"]:ensure(params.music_id)
      self.music_id = params.music_id
   else
      self.music_id = Rand.choice(data["base.music"]:iter():filter(can_generate))._id
   end
end

function ItemMusicDiscAspect:on_use(item, params)
   -- >>>>>>>> shade2/action.hsp:1920 	case effMusicPlayer ...
   Gui.mes("action.use.music_disc.play", item:build_name(1))
   local music_id = self:calc(item, "music_id")
   local map = item:containing_map()
   if map then
      map.music = music_id
   end
   Gui.play_music(music_id)
   -- <<<<<<<< shade2/action.hsp:1924 	swbreak ..
end

function ItemMusicDiscAspect:localize_extra(item)
   local info
   local music_id = self:calc(item, "music_id")
   local music = data["base.music"][music_id]
   if music then
      local ext = data["base.music"]:ext(music_id, "elona.music_disc")
      local name = I18N.localize_optional("base.music", music_id, "name")
      if name then
         info = (" \"%s\""):format(name)
      elseif ext and ext.music_number then
         info = tostring(ext.music_number)
      elseif music.elona_id then
         if music.elona_id > 50 then
            info = tostring(music.elona_id - 50 - 1)
         else
            info = "???"
         end
      else
         info = (" \"%s\""):format(music_id)
      end
   else
      info = "???"
   end
   return ("<BGM%s>"):format(info)
end

return ItemMusicDiscAspect
