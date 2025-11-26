extends Control

@export var inventory: MerchInventory

var merch_item_row: PackedScene = preload("res://game/ui/inventory_ui/merch_inventory_ui/merch_item_row.tscn")

@onready var merch_container: VBoxContainer = %MerchContainer

func _ready() -> void:
    if inventory != null:
        inventory.inventory_changed.connect(update_ui)
    call_deferred("update_ui")

func update_ui() -> void:
    if merch_container == null:
        return

    if inventory == null:
        return

    for child in merch_container.get_children():
        merch_container.remove_child(child)
        child.queue_free()

    for stack in inventory.stacks:
        var row_instance = merch_item_row.instantiate() as MerchItemRow
        row_instance.merch_stack = stack
        merch_container.add_child(row_instance)
