@tool
class_name ActionButton extends TextureButton

@export var action_name: String = "Action":
    set(value):
        action_name = value
        call_deferred("update_ui")

@onready var action_label: Label = %ActionLabel

func _ready() -> void:
    update_ui()

func update_ui() -> void:
    if action_label == null:
        return
    action_label.text = action_name