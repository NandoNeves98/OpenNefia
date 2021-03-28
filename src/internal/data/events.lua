local data = require("internal.data")
local paths = require("internal.paths")
local Event = require("api.Event")
local IEventEmitter = require("api.IEventEmitter")
local Map = require("api.Map")

data:add_multi(
   "base.event",
   {
      { _id = "before_handle_self_event" },
      { _id = "before_ai_decide_action" },
      { _id = "after_chara_damaged", },
      {
         _id = "on_calc_damage",

         params = {
            { name = "test", type = "int", desc = "zxc" }
         },
         returns = {
            { type = "int?" }
         }
      },
      { _id = "after_damage_hp", },
      { _id = "on_damage_chara", },
      { _id = "on_kill_chara", },
      { _id = "before_chara_moved" },
      { _id = "on_chara_moved" },
      { _id = "on_chara_hostile_action", },
      { _id = "on_chara_killed", },
      { _id = "on_calc_kill_exp" },
      { _id = "on_chara_turn_end" },
      { _id = "before_chara_turn_start" },
      { _id = "on_chara_pass_turn" },
      { _id = "on_game_initialize" },
      { _id = "on_map_generated" },
      { _id = "on_map_regenerated" },
      { _id = "on_map_loaded" },
      { _id = "on_map_loaded_from_entrance" },
      { _id = "on_map_rebuilt" },
      { _id = "on_map_deleted" },
      { _id = "on_area_deleted" },
      { _id = "on_proc_status_effect" },
      { _id = "on_object_instantiated" },
      { _id = "on_object_finalized" },
      { _id = "on_chara_instantiated" },
      { _id = "on_item_instantiated" },
      { _id = "on_feat_instantiated" },
      { _id = "on_chara_revived", },
      { _id = "on_talk", },
      { _id = "on_calc_chara_equipment_stats", },
      { _id = "on_engine_init", },
      { _id = "on_data_add" },
      { _id = "on_build_chara" },
      { _id = "on_build_item" },
      { _id = "on_pre_build" },
      { _id = "on_chara_normal_build" },
      { _id = "calc_status_indicators" },
      { _id = "on_refresh" },
      { _id = "on_second_passed" },
      { _id = "on_minute_passed" },
      { _id = "on_hour_passed" },
      { _id = "on_day_passed" },
      { _id = "on_month_passed" },
      { _id = "on_year_passed" },
      { _id = "on_init_save" },
      { _id = "on_build_map" },
      { _id = "on_activity_start" },
      { _id = "on_activity_pass_turns" },
      { _id = "on_activity_finish" },
      { _id = "on_activity_interrupt" },
      { _id = "on_activity_cleanup" },
      { _id = "on_item_generate" },
      { _id = "before_hotload_prototype" },
      { _id = "on_hotload_prototype" },
      { _id = "on_chara_generated" },
      { _id = "on_object_cloned" },
      { _id = "on_map_enter" },
      { _id = "after_map_entered" },
      { _id = "on_map_leave" },
      { _id = "on_chara_place_failure" },
      { _id = "before_map_refresh" },
      { _id = "on_chara_refresh_in_map" },
      { _id = "on_refresh_weight" },
      { _id = "on_calc_speed" },
      { _id = "on_regenerate_map" },
      { _id = "on_regenerate" },
      { _id = "on_item_regenerate" },
      { _id = "on_chara_regenerate" },
      { _id = "on_hotload_object" },
      { _id = "on_chara_vanquished" },
      { _id = "on_turn_begin" },
      { _id = "on_new_game" },
      { _id = "generate_chara_name" },
      { _id = "generate_title" },
      { _id = "on_hotload_begin" },
      { _id = "on_hotload_end" },
      { _id = "on_set_player" },
      { _id = "on_startup" },
      { _id = "on_get_item" },
      { _id = "after_container_receive_item" },
      { _id = "after_container_provide_item" },
      { _id = "on_log_message" },
      { _id = "on_player_turn" },
      { _id = "on_heal_chara_hp", },
      { _id = "on_heal_chara_mp", },
      { _id = "on_damage_chara_mp", },
      { _id = "on_magic_reaction", },
      { _id = "on_recruited_as_ally", },
      { _id = "on_build_mef" },
      { _id = "on_mef_instantiated" },
      { _id = "on_mef_updated" },
      { _id = "on_object_removed" },
      { _id = "on_chara_renewed" },
      { _id = "before_engine_init", },
      { _id = "on_item_init_params", },
      { _id = "on_heal_chara_stamina", },
      { _id = "on_item_renew_major" },
      { _id = "on_map_renew_minor" },
      { _id = "on_map_renew_major", },
      { _id = "on_map_renew_geometry" },
      { _id = "on_map_loaded_events" },
      { _id = "on_map_entered_events" },
      { _id = "calc_map_starting_pos" },
      { _id = "on_generate_area_floor" },
      { _id = "on_map_initialize" },
      { _id = "on_item_build_description" },
      { _id = "on_item_refresh" },
      { _id = "on_item_add_enchantment" },
      { _id = "on_item_remove_enchantment" },
      { _id = "after_get_translation" },
      { _id = "on_initialize_player" },
      { _id = "on_finalize_player" },
      { _id = "on_drop_item" },
      { _id = "on_player_death" },
      { _id = "on_inventory_context_filter" },
      { _id = "on_act_hostile_towards" },
      { _id = "on_map_calc_shadow" },
      { _id = "on_feat_make_target_text" },
      { _id = "on_player_death_revival" },
      { _id = "on_theme_switched" },
      { _id = "on_object_prototype_changed" },
      { _id = "on_chara_calc_can_recruit_allies" },
      { _id = "on_map_generated_from_archetype" },
      { _id = "on_hud_message" },
   }
)
