class_name CalendarEvent extends Resource

@export var title: String = ""
@export var description: String = ""
@export var date: InGameDateTime = null

func _init(t: String, d: InGameDateTime):
    title = t
    date = d