@tool

class_name MessageLogLabel extends RichTextLabel


func _init() -> void:
    # Set custom defaults
    scroll_following = true
    vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM

func _ready() -> void:
    if Engine.has_singleton("MessageLogManager"):
        Engine.get_singleton("MessageLogManager").log_changed.connect(_on_log_changed)
        load_logs()

func _on_log_changed(new_log: MessageLogLine) -> void:
    append_log(new_log)

func load_logs() -> void:
    text = ""
    for log_line in Engine.get_singleton("MessageLogManager").log_list:
        append_log(log_line)

func append_log(log_line: MessageLogLine) -> void:
    var is_tagged = false

    match log_line.type:
        MLConstants.LogType.Important:
            push_color(Color.RED)
            is_tagged = true

    append_text(str(log_line))

    if is_tagged: pop()

    append_text("\n")