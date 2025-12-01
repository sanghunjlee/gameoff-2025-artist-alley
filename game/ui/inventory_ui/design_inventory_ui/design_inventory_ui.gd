@tool
extends Control

signal design_selected(design: DesignResource)

@export var is_selectable: bool = false

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
var design_group: ButtonGroup = ButtonGroup.new()

@onready var title_bar: Control = %TitleBar
@onready var design_container: GridContainer = %DesignContainer

func _ready() -> void:
    if not Engine.is_editor_hint():
        if inventory != null and not inventory.inventory_updated.is_connected(update_ui):
            inventory.inventory_updated.connect(update_ui)
    if title_bar != null:
        title_bar.visible = show_title

    if is_selectable:
        design_group.pressed.connect(_on_design_selected)

    call_deferred("update_ui")

func get_selected() -> DesignResource:
    print_debug("Getting selected design")
    if not is_selectable:
        return null
    
    var selected_button := design_group.get_pressed_button()
    if selected_button == null:
        return null
    
    var slot = selected_button as DesignItemSlot
    print(slot)
    return slot.design

func update_ui() -> void:
    print_debug("Updating Design Inventory UI")
    if inventory == null:
        print_debug("No inventory assigned")
        return

    if design_container == null:
        print_debug("No design container found")
        return

    design_container.columns = columns

    for child in design_container.get_children():
        design_container.remove_child(child)
        child.queue_free()

    for item in inventory.designs:
        var design_ui: DesignItemSlot = design_item_slot_ui.instantiate()
        design_ui.design = item
        if is_selectable:
            design_ui.button_group = design_group
        else:
            design_ui.disabled = true
        design_container.add_child(design_ui)

func _on_design_selected(button: BaseButton) -> void:
    print_debug("Handling design selected signal")
    var slot = button as DesignItemSlot
    design_selected.emit(slot.design)
