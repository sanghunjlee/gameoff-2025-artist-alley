class_name LogManager extends Node

signal log_changed(new_log: LogLine)

var log_list: Array[LogLine] = []

func _ready():
    # Register Log Manager as a singleton
    if not Engine.has_singleton("LogManager"):
        Engine.register_singleton("LogManager", self)

func log(message: String, type: LogConstants.LogType = LogConstants.LogType.Normal):
    var l = LogLine.new(message, type)

    log_list.append(l)
    log_changed.emit(l)