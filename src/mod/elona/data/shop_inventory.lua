local Rand = require("api.Rand")
local Filters = require("mod.elona.api.Filters")
local Enum = require("api.Enum")
local ItemMemory = require("mod.elona_sys.api.ItemMemory")
local Chara = require("api.Chara")
local IItemRod = require("mod.elona.api.aspect.IItemRod")

-- Generates a list to be used with "choices" which will set the
-- provided field to one of the choices in "list".
local function make_choices_list(list, field_name)
   local list = table.deepcopy(list)
   for i, v in ipairs(list) do
      list[i] = { index = i - 1 }
      list[i][field_name] = v
   end
   return list
end

local function make_id_list(list)
   return make_choices_list(list, "id")
end

local function make_filter_list(list)
   return make_choices_list(list, "categories")
end

local deed_items = make_id_list(Filters.isetdeed)

local filter_set_wear = make_filter_list(Filters.fsetwear)

local merchant_rules = {
   { choices = filter_set_wear },
   { quality = 3 },
   { one_in = 2, quality = 4 },
}

local function merchant_item_number()
   return 4 + Rand.rnd(4)
end

--[[
Shop inventory generation is defined using the "rules" field, which is
an array of rules to apply to a generated item. Each rule consists of
one or zero predicates and some properties used in the generation of
the item. This allows inserting/removing values or altering
probabilities without needing to create a new generation function
every time.

The properties that end up being generated by the ruleset will be sent
to Item.create as the arguments table, so whichever arguments
Item.create supports are supported as properties here. Any
unrecognized properties are ignored.

Some notes:
  - Each rule is applied in order of definition in the "rules"
    list.
  - Only the first predicate found in each rule will be applied. If
    no predicates are found, the rule is always applied.

Rule predicates:
  index = 2
    the property is always applied when the 2nd item is being
    generated. Use for defining a set array of items to create.
  one_in = 5
    the property is applied one out of every 5 times. Equivalent to
    rnd(5) == 0.
  all_but_one_in = 5
    the property is always applied except one out of every 5 times.
    Equivalent to rnd(5) != 0.
  predicate = function(args) return args.index > 10 end
    a function, to which the following arguments are passed as a
    table. If it returns true, the properties are applied.
      index: index of the item being generated.
      shopkeeper: character who is the shopkeeper.

Available properties:
  id: string id of the item. If it equals "Skip", skip generation
      of an item this cycle.
  categories: string or {string,...}.
  quality: integer indicating quality.
  choices: an array of properties. one out of the set of properties
           provided will be applied.
  on_generate: a function that will have a table with these fields
               passed to it.
    index: index of the item being generated.
    shopkeeper: character who is the shopkeeper.
]]

local ty_item_categories = types.some(types.data_id("base.item_type"), types.list(types.data_id("base.item_type")))

local ty_shop_inv_rule = types.fields {
   one_in = types.uint,
   all_but_one_in = types.uint,
   categories = ty_item_categories,
   id = types.some(types.data_id("base.item"), types.literal("Skip")),
   choices = types.list(types.fields { categories = types.some(types.data_id("base.item_type"), types.list(types.data_id("base.item_type"))) }),
   predicate = types.callback({"args", types.table}, types.boolean),
   on_generate = types.callback({}, types.table), -- TODO recursive types
}

data:add_type(
   {
      name = "shop_inventory",
      fields = {
         {
            name = "elona_id",
            type = types.uint,
         },
         {
            name = "rules",
            type = types.some(types.list(ty_shop_inv_rule), types.callback({}, types.list(ty_shop_inv_rule)))
         },
         {
            name = "item_number",
            type = types.optional(types.callback({"shopkeeper", types.map_object("base.chara"), "items_to_create", types.uint, "rules", types.list(ty_shop_inv_rule)}, types.uint))
         },
         {
            name = "item_base_value",
            type = types.optional(types.callback({"args", types.table}, types.uint))
         },
         {
            name = "on_generate_item",
            type = types.optional(types.callback("args", types.table))
         },
         {
            name = "restock_interval",
            type = types.positive(types.number)
         },
      }
   }
)
data:add_multi(
   "elona.shop_inventory",
   {
      {
         _id = "magic_vendor",
         elona_id = 1004,
         rules = {
            {
               choices = {
                  {categories = "elona.drink_potion"},
                  {categories = "elona.scroll"},
                  {categories = "elona.drink"},
               }
            },
            { one_in = 7, categories = "elona.spellbook" },
            { one_in = 15, categories = "elona.book" },
            { one_in = 20, id = "elona.recipe" },
         }
      },
      {
         _id = "younger_sister_of_mansion",
         elona_id = 1019,
         rules = {
            { id = "elona.sisters_love_fueled_lunch" }
         }
      },
      {
         _id = "spell_writer",
         elona_id = 1020,
         rules = {
            {
               on_generate = function()
                  local filter = function(_id) return ItemMemory.reserved_state(_id) == "reserved" end
                  local reserved = data["base.item"]:iter():extract("_id"):filter(filter):to_list()

                  if #reserved == 0 then
                     -- NOTE: this used to return out of shop_refresh,
                     -- skipping the update of time_to_restore.
                     -- However, it would be strange to have no books
                     -- reserved, then reserve one and suddenly see
                     -- them available by talking to the shopkeeper
                     -- again immediately, so now the behavior is to
                     -- update time_to_restore anyway if no books are
                     -- reserved at the time of refresh.
                     return { id = "Skip" }
                  end

                  return { id = Rand.choice(reserved) }
               end
            }
         },
         item_base_value = function(args)
            return args.item.value * 3 / 2
         end
      },
      {
         _id = "moyer",
         elona_id = 1015,
         rules = {
            {
               choices = {
                  {categories = "elona.misc_item"},
                  {categories = "elona.equip_ring"},
                  {categories = "elona.equip_neck"},
               }
            },
            { one_in = 3, quality = 3 },
            { one_in = 10, quality = 4 },
         },
         item_base_value = function(args)
            return args.item.value * 2
         end
      },
      {
         _id = "general_vendor",
         elona_id = 1006,
         rules = {
            {
               choices = {
                  {categories = "elona.equip_ammo"},
                  {categories = "elona.furniture"},
                  {categories = "elona.equip_back"},
                  {categories = "elona.ore"},
                  {categories = "elona.misc_item"},
               }
            },
            { one_in = 20, id = "elona.small_gamble_chest" },
            { one_in = 8, categories = "elona.cargo_food" },
            { one_in = 10, choices = deed_items },
         }
      },
      {
         _id = "bakery",
         elona_id = 1003,
         rules = {
            { all_but_one_in = 3, id = "Skip" },
            {
               choices = {
                  {categories = "elona.food_flour"},
                  {categories = "elona.food_flour"},
                  {categories = "elona.food_noodle"},
               }
            },
         }
      },
      {
         _id = "food_vendor",
         elona_id = 1002,
         rules = {
            { all_but_one_in = 3, id = "Skip" },
            { categories = "elona.food" },
            { one_in = 5, categories = "elona.cargo_food" },
         }
      },
      {
         _id = "blackmarket",
         elona_id = 1007,
         rules = {
            { choices = filter_set_wear },
            { one_in = 3, quality = 3  },
            { one_in = 10, quality = 4 },
         },
         item_number = function(shopkeeper, item_number)
            return 6 + shopkeeper.shop_rank / 10
         end,
         item_base_value = function(args)
            -- >>>>>>>> shade2/chat.hsp:3546 	if cRole(tc)=cRoleShopBlack{ ...
            if Chara.player():calc("guild") == "elona.thief" then
               return args.item.value * 2
            else
               return args.item.value * 3
            end
            -- <<<<<<<< shade2/chat.hsp:3548 		} ..
         end
      },
      {
         _id = "wandering_merchant",
         elona_id = 1010,
         rules = merchant_rules,
         item_number = merchant_item_number,
         item_base_value = function(args)
            return args.item.value * 2
         end,
         is_temporary = true -- Uses shop ID 1.
      },
      {
         _id = "visiting_merchant",
         -- NOTE: the only shop ID for which (id / 1000) != 1.
         elona_id = 2003,
         rules = merchant_rules,
         item_number = merchant_item_number,
         item_base_value = function(args)
            return args.item.value * 4 / 5
         end,
         is_temporary = true -- Uses shop ID 1.
      },
      {
         _id = "innkeeper",
         elona_id = 1005,
         rules = {
            { categories = "elona.cargo_food" },
            { one_in = 4, categories = "elona.drink_alcohol" },
            { one_in = 20, id = "elona.small_gamble_chest" },
         }
      },
      {
         _id = "goods_vendor",
         elona_id = 1008,
         rules = {
            { categories = "elona.rod" },
            { one_in = 3, choices = filter_set_wear },
            { one_in = 3, categories = "elona.furniture" },
            { one_in = 5, categories = "elona.food" },
            { one_in = 4, categories = "elona.scroll" },
            { one_in = 15, categories = "elona.book" },
            { one_in = 10, categories = "elona.cargo_food" },
            { one_in = 10, choices = deed_items },
            { one_in = 15, id = "elona.deed_of_heirship" },
         }
      },
      {
         _id = "blacksmith",
         elona_id = 1001,
         rules = {
            {
               choices = {
                  {categories = "elona.equip_body"},
                  {categories = "elona.equip_head"},
                  {categories = "elona.equip_wrist"},
                  {categories = "elona.equip_leg"},
                  {categories = "elona.equip_shield"},
                  {categories = "elona.equip_cloak"},
               }
            },
            {
               one_in = 3,
               choices = {
                  {categories = "elona.equip_melee"},
                  {categories = "elona.equip_ranged"},
                  {categories = "elona.equip_ranged"},
               }
            }
         }
      },
      {
         -- NOTE: Has these special-case behaviors.
         --  + Extra filtering for cargo items when buying/selling
         --    through the "shoptrade" flag.
         --  + You can always sell cargo to traders regardless of how
         --    much money the trader has on hand.
         --  + On shop refresh, updates the buying rates of each cargo
         --    type based on the current map.
         _id = "trader",
         elona_id = 1009,
         rules = {
            { categories = "elona.cargo" },
         },
         restock_interval = 2 * 24
      },
      {
         _id = "the_fence",
         elona_id = 1021,
         rules = {
            { categories = "elona.misc_item" },
            { one_in = 2, id = "elona.lockpick" },
            { one_in = 2, id = "elona.disguise_set" },
         }
      },
      {
         _id = "cyber_dome",
         elona_id = 1011,
         rules = {
            { one_in = 4, categories = "elona.equip_ranged" },
            { one_in = 5, categories = "elona.equip_ranged" },
            { one_in = 3, categories = "elona.equip_food" },
            { categories = "elona.tag_sf" },
         }
      },
      {
         _id = "embassy",
         elona_id = 1012,
         rules = {
            { categories = "elona.furniture" },
            { index = 0, id = "elona.microwave_oven" },
            { index = 1, id = "elona.shop_strongbox" },
            { index = 2, id = "elona.register" },
            { index = 3, id = "elona.salary_chest" },
            { index = 4, id = "elona.freezer" },
            { index = 5, id = "elona.playback_disc" },
            { index = 6, id = "elona.house_board" },
            { predicate = function(args) return args.index > 10 and not Rand.one_in(3) end, id = "Skip" },
            { index = 19, id = "elona.red_treasure_machine" },
            { index = 20, id = "elona.blue_treasure_machine" },
            { index = 21, id = "elona.tax_masters_tax_box" },
         },
      },
      {
         _id = "deed",
         elona_id = 1013,
         rules = {
            { all_but_one_in = 3, id = "Skip" },
            { categories = "elona.book" },
            { one_in = 3, choices = deed_items },
            { one_in = 5, id = "elona.deed_of_heirship" },
         }
      },
      {
         _id = "souvenir_vendor",
         elona_id = 1018,
         ignores_noshop = true,
         rules = {
            { categories = "elona.tag_spshop" },
         },
         item_number = function(shopkeeper, item_number) return item_number / 2 end,
         item_base_value = function(args)
            local price = math.clamp(args.item.value, 1, 1000000) * 50
            if args.item.id == "elona.gift" then
               price = price * 10
            end
            return price
         end
      },
      {
         _id = "street_vendor",
         elona_id = 1022,
         rules = {
            { categories = "elona.tag_fest" },
            { one_in = 12, id = "elona.upstairs" },
            { one_in = 12, id = "elona.downstairs" },
            { one_in = 5, id = "elona.bottle_of_soda" },
            { one_in = 12, id = "elona.festival_wreath" },
            { one_in = 12, id = "elona.new_years_decoration" },
            { one_in = 12, id = "elona.miniature_tree" },
         }
      },
      {
         _id = "dye_vendor",
         elona_id = 1017,
         rules = {
            { id = "elona.bottle_of_dye" },
         }
      },
      {
         _id = "fisher",
         elona_id = 1014,
         rules = {
            { id = "elona.bait" }
         }
      },
      {
         -- NOTE: Has these special-case behaviors.
         --  + Normal generation behavior of sold item number/curse
         --    state is replaced with on_generate_item below. (the
         --    presence of on_generate_item causes all the generation
         --    behavior done after the item is created with
         --    Item.create to be skipped.)
         --  + Item base value is ignored and ctrl_inventory()
         --    (currently) uses a hardcoded value for the number of
         --    medals to sell at.
         --  + Items with Special quality or the precious flag set are
         --    permitted to be sold through a special inventory
         --    routine type in ctrl_inventory() which can only be
         --    triggered through Miral's dialog. In normal shops,
         --    items with those properties are not displayed even if
         --    they are generated successfully.
         _id = "miral",
         elona_id = 1016,
         rules = function()
            -- >>>>>>>> shade2/chat.hsp:3471 	if cRole(tc)=cRoleShopMirok{ ...
            local is_medal_item = function(item) return type(item.medal_value) == "number" end
            local medal_item_ids = data["base.item"]:iter():filter(is_medal_item):to_list()
            return make_id_list(medal_item_ids)
            -- <<<<<<<< shade2/chat.hsp:3492 	} ..
         end,
         item_number = function(_, _, rules)
            -- >>>>>>>> shade2/chat.hsp:3310 	if cRole(tc)=cRoleShopMirok	:p=20 ...
            return #rules
            -- <<<<<<<< shade2/chat.hsp:3310 	if cRole(tc)=cRoleShopMirok	:p=20 ..
         end,
         on_generate_item = function(args)
            -- >>>>>>>> shade2/chat.hsp:3497 	if cRole(tc)=cRoleShopMirok{ ...
            args.item.amount = 1
            args.item.curse_state = Enum.CurseState.Normal
            if args.item._id == "elona.rod_of_domination" then
               args.item:get_aspect(IItemRod).charges = 4
            end
            -- <<<<<<<< shade2/chat.hsp:3501 		} ..
         end
      }
})
