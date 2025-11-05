class_name LogLine extends Resource

@export var message: String = ""
@export var type: LogConstants.LogType = LogConstants.LogType.Normal

var timestamp: int = 0

func _init(message_param: String, type_param: LogConstants.LogType):
    self.message = message_param
    self.type = type_param

func _to_string():
    return self.message  