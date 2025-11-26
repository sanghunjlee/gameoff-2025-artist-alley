@tool
class_name MerchItemRow extends Control

@export var merch_stack: MerchStackResource:
    set(value):
        merch_stack = value
        call_deferred("update_ui")

@onready var icon_rect: TextureRect = %IconRect
@onready var name_label: Label = %MerchNameLabel
@onready var amount_label: Label = %MerchAmountLabel


func _ready() -> void:
    call_deferred("update_ui")

func update_ui() -> void:
    if merch_stack == null:
        return

    icon_rect.texture = merch_stack.merch.design.icon
    name_label.text = str(merch_stack.merch)
    amount_label.text = str(merch_stack.amount)

    
