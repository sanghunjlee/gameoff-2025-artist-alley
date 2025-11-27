class_name DesignItemSlot extends Control

@export var design: DesignResource:
    set(value):
        design = value
        _update_ui()

@onready var design_texture_rect: TextureRect = %DesignTextureRect
@onready var design_label: Label = %DesignLabel

func _ready():
    _update_ui()

func _update_ui() -> void:
    if design == null:
        return
    
    if design_texture_rect == null or design_label == null:
        return

    design_texture_rect.texture = design.icon
    design_label.text = design.title