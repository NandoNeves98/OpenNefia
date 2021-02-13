local Enum = require("api.Enum")

data:add {
   _type = "base.chara",
   _id = "player",

   name = "player",
   race = "elona.norland",
   class = "elona.tourist",
   relation = Enum.Relation.Neutral,
   image = "elona.chara_rabbit",
   level = 1,
   max_hp = 50,
   max_mp = 10,
   rarity = 0,
   coefficient = 400,

   body_parts = {
      "elona.head",
      "elona.neck",
      "elona.back",
      "elona.body",
      "elona.hand",
      "elona.hand",
      "elona.ring",
      "elona.ring",
      "elona.arm",
      "elona.arm",
      "elona.waist",
      "elona.leg",
      "elona.ranged",
      "elona.ammo"
   }
}
