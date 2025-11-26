extends Control

@export var inventory: DesignInventory

@onready var design_container: VBoxContainer = %DesignContainer

func _ready() -> void:
    DesignManager.design_completed.connect(update_ui)
    call_deferred("update_ui")

func update_ui(_design: DesignResource) -> void:
    print("Updating Design Inventory UI")
    if inventory == null:
        print("No inventory assigned")
        return

    for child in design_container.get_children():
        design_container.remove_child(child)
        child.queue_free()

    for item in inventory.designs:
        var design_ui: Label = Label.new()
        design_ui.text = str(item)
        design_container.add_child(design_ui)
