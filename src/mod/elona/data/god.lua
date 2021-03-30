local God = require("mod.elona.api.God")

local function secret_treasure(id)
   return { id = "elona.secret_treasure", param1 = id, nostack = true }
end

local god = {
   {
      _id = "mani",
      elona_id = 1,
      generate_altars = true,

      wish_name = "mani",
      summon = "elona.mani",
      servant = "elona.android",
      items = {
         { id = "elona.gemstone_of_mani", _only_once = true }
      },
      artifact = "elona.winchester_premium",
      blessings = {
         God.make_skill_blessing("elona.stat_dexterity", 400, 8),
         God.make_skill_blessing("elona.stat_perception", 300, 14),
         God.make_skill_blessing("elona.healing", 500, 8),
         God.make_skill_blessing("elona.firearm", 250, 18),
         God.make_skill_blessing("elona.detection", 350, 8),
         God.make_skill_blessing("elona.lock_picking", 250, 16),
         God.make_skill_blessing("elona.carpentry", 300, 10),
         God.make_skill_blessing("elona.jeweler", 350, 12),
      },
      offerings = {
         "elona.laser_gun",
         "elona.shot_gun",
         "elona.blank_disc",
         "elona.chip",
         "elona.storage",
         "elona.server",
         "elona.microwave_oven",
         "elona.camera",
         "elona.training_machine",
         "elona.computer",
         "elona.machine",
         "elona.machine_gun",
         "elona.pistol",
      }
   },
   {
      _id = "lulwy",
      elona_id = 2,
      generate_altars = true,

      wish_name = "lulwy",
      summon = "elona.lulwy",
      servant = "elona.black_angel",
      items = {
         { id = "elona.lulwys_gem_stone_of_god_speed", _only_once = true }
      },
      artifact = "elona.wind_bow",
      blessings = {
         God.make_skill_blessing("elona.stat_perception", 450, 10),
         God.make_skill_blessing("elona.stat_speed", 350, 30),
         God.make_skill_blessing("elona.bow", 350, 16),
         God.make_skill_blessing("elona.crossbow", 450, 12),
         God.make_skill_blessing("elona.stealth", 450, 12),
         God.make_skill_blessing("elona.magic_device", 550, 8),
      },
      offerings = {
         "elona.skull_bow",
         "elona.crossbow",
         "elona.short_bow",
         "elona.long_bow",
      },
   },
   {
      _id = "itzpalt",
      elona_id = 3,
      generate_altars = true,

      wish_name = "itzpalt",
      servant = "elona.exile",
      items = {
         secret_treasure(165),
      },
      artifact = "elona.elemental_staff",
      blessings = {
         God.make_skill_blessing("elona.stat_magic", 300, 18),
         God.make_skill_blessing("elona.meditation", 350, 15),
         God.make_skill_blessing("elona.element_fire", 50, 200),
         God.make_skill_blessing("elona.element_cold", 50, 200),
         God.make_skill_blessing("elona.element_lightning", 50, 200),
      },
      offerings = {
         "elona.long_staff",
         "elona.staff",
      },
   },
   {
      _id = "ehekatl",
      elona_id = 4,
      generate_altars = true,

      wish_name = "ehekatl",
      summon = "elona.ehekatl",
      servant = "elona.black_cat",
      items = {
         secret_treasure(163),
      },
      artifact = "elona.lucky_dagger",
      blessings = {
         God.make_skill_blessing("elona.stat_charisma", 250, 20),
         God.make_skill_blessing("elona.stat_luck", 100, 50),
         God.make_skill_blessing("elona.evasion", 300, 15),
         God.make_skill_blessing("elona.magic_capacity", 350, 17),
         God.make_skill_blessing("elona.fishing", 300, 12),
         God.make_skill_blessing("elona.lock_picking", 450, 8),
      },
      offerings = {
         "elona.fish",
         "elona.sandborer",
         "elona.cutlassfish",
         "elona.tuna",
         "elona.globefish",
         "elona.salmon",
         "elona.seabream",
         "elona.manboo",
         "elona.flatfish",
         "elona.sardine",
         "elona.moonfish",
         "elona.bomb_fish",
      }
   },
   {
      _id = "opatos",
      elona_id = 5,
      generate_altars = true,

      wish_name = "opatos",
      summon = "elona.opatos",
      servant = "elona.golden_knight",
      items = {
         secret_treasure(164),
      },
      artifact = "elona.gaia_hammer",
      blessings = {
         God.make_skill_blessing("elona.stat_strength", 450, 11),
         God.make_skill_blessing("elona.stat_constitution", 350, 16),
         God.make_skill_blessing("elona.shield", 350, 15),
         God.make_skill_blessing("elona.weight_lifting", 300, 16),
         God.make_skill_blessing("elona.mining", 350, 12),
         God.make_skill_blessing("elona.magic_device", 450, 8),
      },
      offerings = {
         "elona.junk_stone",
         "elona.raw_ore_of_diamond",
         "elona.raw_ore_of_emerald",
         "elona.raw_ore_of_mica",
         "elona.raw_ore_of_rubynus",
         "elona.gold_bar",
         "elona.sun_crystal",
         "elona.mana_crystal",
         "elona.earth_crystal",
      }
   },
   {
      _id = "jure",
      elona_id = 6,
      generate_altars = true,

      wish_name = "jure",
      servant = "elona.defender",
      items = {
         { id = "elona.jures_gem_stone_of_holy_rain", _only_once = true },
         secret_treasure(166),
      },
      artifact = "elona.holy_lance",
      blessings = {
         God.make_skill_blessing("elona.stat_will", 300, 16),
         God.make_skill_blessing("elona.healing", 250, 18),
         God.make_skill_blessing("elona.meditation", 400, 10),
         God.make_skill_blessing("elona.anatomy", 400, 9),
         God.make_skill_blessing("elona.cooking", 450, 8),
         God.make_skill_blessing("elona.magic_device", 400, 10),
         God.make_skill_blessing("elona.magic_capacity", 400, 12),
      },
      offerings = {
         "elona.junk_stone",
         "elona.raw_ore_of_diamond",
         "elona.raw_ore_of_emerald",
         "elona.raw_ore_of_mica",
         "elona.raw_ore_of_rubynus",
         "elona.gold_bar",
         "elona.sun_crystal",
         "elona.mana_crystal",
         "elona.earth_crystal",
      },
   },
   {
      _id = "kumiromi",
      elona_id = 7,
      generate_altars = true,

      wish_name = "kumiromi",
      summon = "elona.kumiromi",
      servant = "elona.cute_fairy",
      items = {
         { id = "elona.kumiromis_gem_stone_of_rejuvenation", _only_once = true },
      },
      artifact = "elona.kumiromi_scythe",
      blessings = {
         God.make_skill_blessing("elona.stat_perception", 400, 8),
         God.make_skill_blessing("elona.stat_dexterity", 350, 12),
         God.make_skill_blessing("elona.stat_learning", 250, 16),
         God.make_skill_blessing("elona.gardening", 300, 12),
         God.make_skill_blessing("elona.alchemy", 350, 10),
         God.make_skill_blessing("elona.tailoring", 350, 9),
         God.make_skill_blessing("elona.literacy", 350, 8),
      },
      offerings = {
         "elona.magical_seed",
         "elona.gem_seed",
         "elona.artifact_seed",
         "elona.unknown_seed",
         "elona.herb_seed",
         "elona.fruit_seed",
         "elona.vegetable_seed",
         "elona.leccho",
         "elona.melon",
         "elona.cbocchi",
         "elona.green_pea",
         "elona.healthy_leaf",
         "elona.imo",
         "elona.lettuce",
         "elona.sweet_potato",
         "elona.radish",
         "elona.carrot",
         "elona.edible_wild_plant",
      }
   },
}

data:add_multi("elona.god", god)
