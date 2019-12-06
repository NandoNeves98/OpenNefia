local event = {
      { _id = "on_apply_effect" },
      { _id = "on_heal_effect" },
      { _id = "calc_effect_power" },
      { _id = "on_player_bumped_into_chara", },
      { _id = "before_player_map_leave" },
      { _id = "on_bump_into" },
      { _id = "on_quest_check" },
      { _id = "on_item_use" },
      { _id = "on_item_eat" },
      { _id = "on_item_drink" },
      { _id = "on_item_read" },
      { _id = "on_item_zap" },
      { _id = "on_bash" },
      { _id = "on_search" },
      { _id = "on_feat_activate" },
      { _id = "on_feat_search" },
      { _id = "on_feat_open" },
      { _id = "on_feat_close" },
      { _id = "on_feat_descend" },
}

data:add_multi("base.event", event)
