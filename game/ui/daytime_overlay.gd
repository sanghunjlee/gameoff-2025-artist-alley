extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var colors = {
    "morning": Color(0, 0, 0.2, 0.1),
    "afternoon": Color(0, 0, 0, 0),
    "evening": Color(.1, 0, .1, 0.1),
    "night": Color(0, 0, 0.3, 0.25)
}


func _ready() -> void:
    TimeManager.connect("time_updated", Callable(self, "_on_time_updated"))
    _update_overlay()

func _on_time_updated() -> void:
    _update_overlay()

func _update_overlay() -> void:
    var current_time = TimeManager.get_current_daytime()
    if current_time in colors:
        color_rect.color = colors[current_time]
    else:
        color_rect.color = Color(1, 1, 1, 0)
