extends Node
# manages changing scenes

func change_scene_to(scene: PackedScene) -> void:
    GameState.current_scene = scene

    # If leaving main scene, pause time
    if scene != GameState.scenes_data.main_scene:
        TimeManager.force_pause_time()
    else:
        TimeManager.play_time()

    get_tree().change_scene_to_packed(scene)
