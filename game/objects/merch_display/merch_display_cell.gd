class_name MerchDisplayCell extends Node2D

@onready var merch_stack: MerchStackResource = null:
    set(value):
        merch_stack = value
        update_display()
var stack_index: int = -1
@export var merch_sprite: Sprite2D
@export var base_sprite: Sprite2D
@export var out_of_stock_sprite: Sprite2D

func _ready() -> void:
    # Connect to inventory updates
    GameState.merch_inventory.connect("out_of_stock", Callable(self, "_on_out_of_stock"))

func update_display() -> void:
    if merch_stack == null or merch_stack.amount <= 0:
        out_of_stock_sprite.visible = true
        return

    # if detected update to this cell's merch stack
    out_of_stock_sprite.visible = false
    merch_sprite.visible = true
    merch_sprite.texture = merch_stack.merch.design.icon

func _on_out_of_stock(index: int) -> void:
    # print_debug("MerchDisplayCell detected out_of_stock for index: ", index)
    # print_debug("Current cell stack_index: ", stack_index)
    if index == stack_index:
        update_display()
