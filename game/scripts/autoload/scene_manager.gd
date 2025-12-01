extends Node
# manages changing scenes
@onready var title_scene: PackedScene = GameState.scenes_data.title_scene
@onready var convention_scene: PackedScene = GameState.scenes_data.convention_scene
@onready var game_over_scene: PackedScene = GameState.scenes_data.game_over_scene
@onready var main_scene: PackedScene = GameState.scenes_data.main_scene


func change_scene_to(scene: PackedScene) -> void:
    GameState.current_scene = scene

    # If leaving main scene, pause time
    if scene != main_scene:
        TimeManager.force_pause_time()
    else:
        TimeManager.play_time()

    get_tree().change_scene_to_packed(scene)
