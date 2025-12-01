extends Control


func _on_restart_button_pressed() -> void:
    SceneManager.change_scene_to(SceneManager.main_scene)
