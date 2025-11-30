extends Node
# manages changing scenes
var scenes_data: ScenesData = preload("res://game/resources/scenes/ScenesData.tres")
var main_scene = scenes_data.main_scene
var convention_scene = scenes_data.convention_scene

func change_scene_to(scene: PackedScene) -> void:
    get_tree().change_scene_to_packed(scene)
