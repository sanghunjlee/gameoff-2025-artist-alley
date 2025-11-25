extends Node

signal log_changed(new_log: MessageLogLine)

var log_list: Array[MessageLogLine] = []

func _ready():
    if not Engine.has_singleton("MessageLogManager"):
        Engine.register_singleton("MessageLogManager", self)

func append_log(message: String, type: MLConstants.LogType = MLConstants.LogType.Normal):
    var l = MessageLogLine.new(message, type)
    l.timestamp = GameState.time_count

    log_list.append(l)
    log_changed.emit(l)