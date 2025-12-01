@tool
extends Control

@export var event: CalendarEvent = null:
    set(value):
        event = value
        update_ui()

@onready var event_title_label: Label = %EventTitleLabel

func _ready():
    update_ui()

func update_ui():
    if event_title_label == null:
        return

    event_title_label.text = event.title
    
