extends Node
# manages changing scenes

func change_scene_to(scene: PackedScene) -> void:
    GameState.current_scene = scene
    get_tree().change_scene_to_packed(scene)
