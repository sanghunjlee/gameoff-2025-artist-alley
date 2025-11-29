@tool
extends Control

@export var show_title: bool = true:
    set(value):
        show_title = value
        if title_bar != null:
            title_bar.visible = show_title

@export var inventory: DesignInventory:
    set(value):
        if inventory != value and value != null:
            if Engine.is_editor_hint():
                inventory = value
            else:
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

@onready var title_bar: Control = %TitleBar
@onready var design_container: GridContainer = %DesignContainer

func _ready() -> void:
    # Uncommented because this is defined in the setter of 'inventory', no? Same case in merch inv ui -sabrina
    # if inventory != null:
    #     inventory.inventory_updated.connect(update_ui)
    if title_bar != null:
        title_bar.visible = show_title

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
