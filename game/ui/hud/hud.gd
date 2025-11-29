extends Node

@export var current_tab: int = 0:
    set(value):
        current_tab = value
        _update_tab_visibility()

@onready var home_tab: Control = %HomeTab
@onready var inventory_tab: Control = %InventoryTab


func _ready():
    _update_tab_visibility()

func _update_tab_visibility() -> void:
    home_tab.visible = current_tab == 0
    inventory_tab.visible = current_tab == 2

func _on_home_tab_selected() -> void:
    current_tab = 0

func _on_calendar_tab_selected() -> void:
    current_tab = 1

func _on_inventory_tab_selected() -> void:
    current_tab = 2
