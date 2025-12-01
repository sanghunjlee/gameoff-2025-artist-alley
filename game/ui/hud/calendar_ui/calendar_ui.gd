@tool
extends Control

@export_tool_button(
    "Populate Cells",
    "Callable"
)
var populate_cells_button = populate_cells

@export_tool_button(
    "Populate Events",
    "Callable"
)
var populate_events_button = populate_events

var calendar_cell_scene: PackedScene = preload("res://game/ui/hud/calendar_ui/calendar_cell.tscn")

@onready var cell_grid_container: GridContainer = %CellGridContainer

func _ready() -> void:
    populate_cells()
    call_deferred("populate_events")

func populate_cells() -> void:
    for child in cell_grid_container.get_children():
        cell_grid_container.remove_child(child)
        child.queue_free()
        
    for day in range(28):
        print_debug("Creating a calendar cell for:", day)
        var cell_instance: Control = calendar_cell_scene.instantiate()
        cell_instance.day = day
        cell_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        cell_instance.size_flags_vertical = Control.SIZE_EXPAND_FILL

        cell_grid_container.add_child(cell_instance)

func populate_events() -> void:
    print_debug("Populating events")
    if cell_grid_container == null:
        return

    if cell_grid_container.get_child_count() == 0:
        return

    for child in cell_grid_container.get_children():
        if "day" in child and child.day % 7 == 6:
            if child.has_method("add_event"):
                print_debug("Adding event for:", child.day)
                var current_month = 0
                if not Engine.is_editor_hint():
                    current_month = TimeManager.get_current_month()
                
                var con_date = InGameDateTime.new(0, current_month , child.day)
                var con_event = CalendarEvent.new("Convention", con_date)
                child.add_event(con_event)
