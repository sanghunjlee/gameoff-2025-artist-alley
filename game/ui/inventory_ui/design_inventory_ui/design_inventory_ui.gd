extends Control

@export var inventory: DesignInventory:
    set(value):
        if inventory != value and value != null:
            if inventory != null and inventory.inventory_updated.is_connected(update_ui):
                inventory.inventory_updated.disconnect(update_ui)
            inventory = value
            if not inventory.inventory_updated.is_connected(update_ui):
                inventory.inventory_updated.connect(update_ui)
            update_ui()

@export var columns: int = 4:
    set(value):
        columns = value
        update_ui()

var design_item_slot_ui: PackedScene = preload("res://game/ui/inventory_ui/design_inventory_ui/design_item_slot.tscn")

@onready var design_container: GridContainer = %DesignContainer

func _ready() -> void:
    if inventory != null:
        inventory.inventory_updated.connect(update_ui)
    call_deferred("update_ui")

func update_ui() -> void:
    print("Updating Design Inventory UI")
    if inventory == null:
        print("No inventory assigned")
        return

    if design_container == null:
        print("No design container found")
        return

    design_container.columns = columns

    for child in design_container.get_children():
        design_container.remove_child(child)
        child.queue_free()

    for item in inventory.designs:
        var design_ui: DesignItemSlot = design_item_slot_ui.instantiate()
        design_ui.design = item
        design_container.add_child(design_ui)
