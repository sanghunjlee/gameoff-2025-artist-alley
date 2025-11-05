@tool

class_name LogLabel extends RichTextLabel


func _ready() -> void:
    Engine.get_singleton("LogManager").log_changed.connect(_on_log_changed)

    load_logs()

func _on_log_changed(new_log: LogLine) -> void:
    text += str(new_log) + "\n"


func load_logs() -> void:
    text = ""
    for log_line in Engine.get_singleton("LogManager").log_list:
        text += str(log_line) + "\n"