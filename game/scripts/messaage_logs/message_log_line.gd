class_name MessageLogLine extends Resource

@export var message: String = ""
@export var type: MLConstants.LogType = MLConstants.LogType.Normal

var timestamp: int = 0

func _init(message_param: String, type_param: MLConstants.LogType):
    self.message = message_param
    self.type = type_param

func _to_string():
    
    return "%s" % [self.message]  