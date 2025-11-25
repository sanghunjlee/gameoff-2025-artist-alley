extends Control

# Time (in seconds) to wait before hiding the log panel
var wait_time: float = 20.0 

var t: float = 0.0

func _ready() -> void:
    visible = false
    MessageLogManager.log_changed.connect(_on_log_changed)
    

func _process(delta: float) -> void:
    if t <= 0.0:
        visible = false
    else:
        t -= delta

func _on_log_changed(_new_log: MessageLogLine) -> void:
    visible = true
    t = wait_time


