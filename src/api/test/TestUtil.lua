local Save = require("api.Save")
local InstancedArea = require("api.InstancedArea")
local Area = require("api.Area")
local Map = require("api.Map")
local Chara = require("api.Chara")
local field = require("game.field")
local Item = require("api.Item")
local Enum = require("api.Enum")
local IItem = require("api.item.IItem")

local TestUtil = {}

TestUtil.TEST_MOD_ID = "@test@"
TestUtil.TEST_SAVE_ID = "__test__"

function TestUtil.set_player(map, x, y)
   if map == nil then
      field.player = assert(TestUtil.stripped_chara("base.player", nil, x, y))
      return field.player
   else
      local player = assert(TestUtil.stripped_chara("base.player", map, x, y))
      Chara.set_player(player)
      return player
   end
end

function TestUtil.register_map(map)
   assert(Chara.player(), "player must be set")
   local area = InstancedArea:new()
   Area.register(area, { parent = "root" })
   area:add_floor(map, 1)
   Map.save(map)
   Map.set_map(map)
end

function TestUtil.save_cycle()
   Save.save_game(TestUtil.TEST_SAVE_ID)
   Save.load_game(TestUtil.TEST_SAVE_ID)
end

function TestUtil.stripped_chara(id, map, x, y)
   local chara
   if map then
      chara = Chara.create(id, x, y, {}, map)
   else
      chara = Chara.create(id, nil, nil, {ownerless=true})
   end
   chara:iter_items():each(IItem.remove_ownership)
   -- TODO event
   chara.god = nil
   return chara
end

function TestUtil.stripped_item(id, map, x, y, amount)
   local item
   if map == nil then
      item = Item.create(id, x, y, {ownerless=true,amount=amount or 1})
   else
      item = Item.create(id, x, y, {amount=amount or 1}, map)
   end
   item.curse_state = Enum.CurseState.Normal
   item.spoilage_date = nil
   return item
end

return TestUtil
