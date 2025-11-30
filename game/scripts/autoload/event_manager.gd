extends Node

func _ready() -> void:
    TimeManager.connect("time_updated", Callable(self, "_on_time_updated"))

func _on_time_updated(_time_count: int) -> void:
    if _time_count == 24 * 7: # 1 week
        SceneManager.change_scene_to(SceneManager.convention_scene)