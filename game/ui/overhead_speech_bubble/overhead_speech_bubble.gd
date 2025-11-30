extends Control
class_name OverheadSpeechBubble

const DEFAULT_SHOW_TIME: float = 2.0
@export var display_timer: Timer

func _ready() -> void:
    pass


# Messages should be kept short (few words) to fit in the bubble nicely.
func show_message(_text: String, _seconds_to_show: float = DEFAULT_SHOW_TIME) -> void:
    %Label.text = _text
    visible = true
    display_timer.start(_seconds_to_show)
    await display_timer.timeout
    visible = false

# func center_bubble_horizontal_to_parent() -> void:
#     var parent_width = get_parent().rect_size.x
