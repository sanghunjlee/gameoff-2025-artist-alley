class_name MerchDisplayCell extends Node2D

var merch_stack: MerchStackResource = null
var is_out: bool = false

@export var merch_sprite: Sprite2D
@export var base_sprite: Sprite2D
@export var out_of_stock_sprite: Sprite2D

func _ready() -> void:
    # Connect to inventory updates
    GameState.merch_inventory.inventory_updated.connect(_on_inventory_updated)
    update_display()

func update_display() -> void:
    out_of_stock_sprite.visible = is_out
    if not merch_sprite.visible:
        merch_sprite.visible = true

func _on_inventory_updated() -> void:
    if merch_stack == null:
        return 
    
    var index = GameState.merch_inventory.find_merch(merch_stack.merch)    
    if index == -1:
        # Probably out of stock
        is_out = true
        update_display()
