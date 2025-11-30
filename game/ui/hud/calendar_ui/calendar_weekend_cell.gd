@tool
extends Control

@export var day: int = 1:
    set(value):
        day = value
        update_ui()


@export var day_label: Label

func _ready() -> void:
    call_deferred("update_ui")

func update_ui() -> void:
    day_label.text = str(day)
