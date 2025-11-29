extends Control

@export var inventory: MerchInventory:
    set(value):
        if inventory != value and value != null:
            if inventory != null and inventory.inventory_updated.is_connected(update_ui):
                inventory.inventory_updated.disconnect(update_ui)
            inventory = value
            if not inventory.inventory_updated.is_connected(update_ui):
                inventory.inventory_updated.connect(update_ui)
            update_ui()

var merch_item_row: PackedScene = preload("res://game/ui/inventory_ui/merch_inventory_ui/merch_item_row.tscn")

@onready var merch_container: VBoxContainer = %MerchContainer

func _ready() -> void:
    if inventory != null:
        inventory.inventory_updated.connect(update_ui)
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
        var row_instance: MerchItemRow = merch_item_row.instantiate()
        row_instance.merch_stack = stack
        merch_container.add_child(row_instance)
