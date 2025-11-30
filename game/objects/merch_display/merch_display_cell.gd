class_name MerchDisplayCell extends Node2D

@onready var merch_stack: MerchStackResource = null:
    set(value):
        merch_stack = value
        update_display()

@export var merch_sprite: Sprite2D
@export var base_sprite: Sprite2D
@export var out_of_stock_sprite: Sprite2D

func _ready() -> void:
    # Connect to inventory updates
    GameState.merch_inventory.connect("inventory_updated", Callable(self, "update_display"))

func update_display() -> void:
    if merch_stack:
        if merch_stack.amount <= 0:
            out_of_stock_sprite.visible = true
            # merch_sprite.visible = false
            return

        out_of_stock_sprite.visible = false
        merch_sprite.visible = true
        merch_sprite.texture = merch_stack.merch.design.icon
