local Chara = require("game.Chara")
local GUI = require("game.GUI")
local Internal = require("game.Internal")
local Item = require("game.Item")

local common = require_relative("data/dialog/common")

return {
   id = "mia",
   root = "core.talk.unique.mia",
   nodes = {
      __start = function()
         local flag = Sidequest.progress("elona.mias_dream")
         if flag == 1000 then
            return "quest_completed"
         elseif flag == 0 then
            return "quest_ask"
         elseif flag == 1 then
            return "quest_check"
         end

         return "elona_sys.ignores_you:__start"
      end,
      quest_completed = {
         text = {
            {"complete"},
         },
      },
      quest_ask = {
         text = {
            {"quest.dialog"},
         },
         choices = {
            {"quest_yes", "quest.choices.yes"},
            {"quest_no", "quest.choices.no"}
         },
         default_choice = "quest_no"
      },
      quest_yes = {
         text = {
            GUI.show_journal_update_message,
            {"quest.yes"},
         },
         on_finish = function()
            Sidequest.set_progress("elona.mias_dream", 1)
         end
      },
      quest_no = {
         text = {
            {"quest.no"},
         },
      },
      quest_check = function()
         if Chara.find("core.silver_cat", "Allies") == nil then
            return "quest_waiting"
         end

         return "quest_finish"
      end,
      quest_waiting = {
         text = {
            {"quest.waiting"}
         }
      },
      quest_finish = {
         text = {
            {"quest.end._0"},
            {"quest.end._1"},
         },
         on_finish = function()
            Item.create(Chara.player().position, "core.monster_heart", 0)
            Item.create(Chara.player().position, "core.gold_piece", 5000)
            Item.create(Chara.player().position, "core.platinum_coin", 3)

            common.quest_completed()

            Sidequest.set_progress("elona.mias_dream", 1000)

            local silver_cat = Chara.find("core.silver_cat", "Allies")
            Chara.remove_from_party(silver_cat)
            silver_cat.relationship = "Unconcerned"
            silver_cat.original_relationship = "Unconcerned"
            silver_cat.role = 3
         end
      }
   }
}
