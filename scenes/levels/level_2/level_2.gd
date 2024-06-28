extends BlankLevel

func _on_level_finished() -> void:
	Globals.is_game_active = false
	fade_bgm(-80, 3)
	get_tree().change_scene_to_file("res://scenes/levels/level_3/level_3.tscn")
