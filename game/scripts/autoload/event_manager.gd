extends Node

func _ready() -> void:
    TimeManager.connect("time_updated", Callable(self, "_on_time_updated"))
    StatsManager.connect("money_depleted", Callable(self, "go_to_game_over"))

func _on_time_updated() -> void:
    if TimeManager.get_current_day() % 7 == 0 and GameState.current_scene == GameState.scenes_data.main_scene:
        go_to_convention()

func go_to_convention() -> void:
    StatsManager.handle_task_action(GameState.PlayerTaskType.NONE)
    SceneManager.change_scene_to(GameState.scenes_data.convention_scene)

func go_to_game_over() -> void:
    SceneManager.change_scene_to(GameState.scenes_data.game_over_scene)