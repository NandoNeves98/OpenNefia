--- Code for the quickstart scenario.
local Item = require("api.Item")
local Pos = require("api.Pos")
local Map = require("api.Map")
local InstancedMap = require("api.InstancedMap")
local Text = require("mod.elona.api.Text")
local Area = require("api.Area")
local Log = require("api.Log")
local Rand = require("api.Rand")
local Gui = require("api.Gui")
local World = require("api.World")
local Layout = require("mod.tools.api.Layout")
local Chara = require("api.Chara")

local arc = {
   _type = "base.map_archetype",
   _id = "test_room"
}

function arc.on_map_renew_minor(map)
   for _=1, 50 do
      local x = Rand.rnd(map:width())
      local y = Rand.rnd(map:height())
      map:set_tile(x, y, "elona.brick_1")
   end
end

function arc.on_map_renew_major(map)
   for _=1, 50 do
      local x = Rand.rnd(map:width())
      local y = Rand.rnd(map:height())
      map:set_tile(x, y, "elona.cobble_caution")
   end
end

function arc.on_map_minor_events(map)
   local to_minor = map.renew_minor_date - World.date_hours()
   local to_major = map.renew_major_date - World.date_hours()
   Gui.mes_c("Time to minor renew: " .. to_minor .. " hours", "Yellow")
   Gui.mes_c("Time to major renew: " .. to_major .. " hours", "Yellow")
end

function arc.on_map_renew_geometry(map)
   for _, x, y in Pos.iter_rect(10, 10, 20, 20) do
      map:set_tile(x, y, "elona.wall_dirt_dark_top")
   end
end

data:add(arc)


local putit_room = {
   _type = "base.map_archetype",
   _id = "putit_room"
}

function putit_room.on_map_minor_events(map)
   Gui.mes_c("*puti*", "Yellow")
end

function putit_room.on_generate_map(area, floor)
   local tiles = [[
OOOOOOOOOOOOOOOO
OOOOOOOOOOOOOOOO
OOOOOOOOOOO##OOO
OOOOOOOOOO#..#OO
OOO#######...#OO
OO#..........#OO
O#..x...x....#OO
O#..x...x....#OO
O#..x...x....#OO
O#...........#OO
O#...........#OO
OO#........##OOO
OOO########OOOOO
OOOOOOOOOOOOOOOO
OOOOOOOOOOOOOOOO
OOOOOOOOOOOOOOOO]]

   local tileset = {
      ["."] = "elona.cobble_diagonal",
      ["#"] = "elona.wall_stone_3_top",
      ["O"] = "elona.wall_dirt_dark_top",
      ["x"] = "elona.cyber_4"
   }

   local map = Layout.to_map({tiles = tiles, tileset = tileset})

   for _ = 1, 20 do
      Chara.create("elona.putit", nil, nil, {}, map)
   end

   local parent_area = Area.parent(area)
   assert(Area.create_stairs_up(parent_area, 1, 7, 7, { force = true }, map))

   return map
end

putit_room.properties = {
   is_indoor = true,
   turn_cost = 1000000,
   name = "Putit Room",
   default_tile = "elona.wall_stone_3_fog"
}

data:add(putit_room)
data:add {
   _type = "base.area_archetype",
   _id = "putit_room",

   floors = {
      [1] = "test_room.putit_room"
   },

   image = "elona.feat_area_tent",

   parent_area = {
      _id = "test_room.test_room",
      on_floor = 1,
      x = 23,
      y = 25,
      starting_floor = 1
   }
}


local the_dungeon = {
   _type = "base.area_archetype",
   _id = "the_dungeon",
   image = "elona.feat_area_crypt"
}

function the_dungeon.on_generate_floor(area, floor)
   local map = InstancedMap:new(20, 25)
   map:clear("elona.hardwood_floor_5")
   map.name = "The Dungeon"
   map.is_indoor = true
   map.default_tile = "elona.wall_stone_3_fog"

   if floor == 1 then
      local parent_area = Area.parent(area)
      assert(Area.create_stairs_up(parent_area, 1, 5, 5, {}, map))
   end

   if floor > 1 then
      assert(Area.create_stairs_down(area, floor - 1, 12, 15, {}, map))
   end
   if floor < 10 then
      assert(Area.create_stairs_up(area, floor + 1, 8, 15, {}, map))
   end

   return map
end

the_dungeon.parent_area = {
   _id = "test_room.test_room",
   on_floor = 1,
   x = 27,
   y = 25,
   starting_floor = 1
}

data:add(the_dungeon)


local test_room = {
   _type = "base.area_archetype",
   _id = "test_room"
}

function test_room.on_generate_floor(area, floor)
   local map = InstancedMap:new(50, 50)
   map:set_archetype("test_room.test_room")
   map:clear("elona.cobble")
   map.is_indoor = true
   map.name = "Test Room"
   for _, x, y in Pos.iter_border(0, 0, 50 - 1, 50 - 1) do
      map:set_tile(x, y, "elona.wall_dirt_dark_top")
   end

   for _, x, y in map:iter_tiles() do
      map:memorize_tile(x, y)
   end

   return map
end

data:add(test_room)


local function on_game_start(self, player)
   local bow = Item.create("elona.long_bow", nil, nil, { ownerless = true })
   local arrow = Item.create("elona.arrow", nil, nil, { ownerless = true })
   player:equip_item(bow, true)
   player:equip_item(arrow, true)

   Item.create("elona.putitoro", nil, nil, {}, player)
   Item.create("elona.rod_of_identify", nil, nil, {}, player)
   Item.create("elona.stomafillia", nil, nil, {}, player)

   player:heal_to_max()

   player.title = Text.random_title()

   local root_area = Area.create_unique("test_room.test_room", "root")
   local _, map = assert(root_area:load_or_generate_floor(1))

   local north_tyris = Area.create_unique("elona.north_tyris", root_area)
   assert(Area.create_entrance(north_tyris, 1, 25, 23, {}, map))

   Map.set_map(map)
   map:take_object(player, 25, 25)
end

data:add {
   _type = "base.scenario",
   _id = "test_room",

   on_game_start = on_game_start
}
