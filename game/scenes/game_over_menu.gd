extends Control


func _on_restart_button_pressed() -> void:
	StatsManager.reset_stats()
	SceneManager.change_scene_to(GameState.scenes_data.main_scene)
