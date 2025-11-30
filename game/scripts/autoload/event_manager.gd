extends Node

var con_happened: bool = false

func _ready() -> void:
    TimeManager.connect("time_updated", Callable(self, "_on_time_updated"))

func _on_time_updated() -> void:
    if TimeManager.get_current_day() % 7 == 0 and !con_happened:
        SceneManager.change_scene_to(SceneManager.convention_scene)
        con_happened = true