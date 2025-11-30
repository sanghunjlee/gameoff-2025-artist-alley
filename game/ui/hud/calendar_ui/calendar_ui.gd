@tool
extends Control

@export_tool_button(
    "Populate Cells",
    "Callable"
)
var populate_cells_button = populate_cells

var weekday_cell_scene: PackedScene = preload("res://game/ui/hud/calendar_ui/calendar_weekday_cell.tscn")
var weekend_cell_scene: PackedScene = preload("res://game/ui/hud/calendar_ui/calendar_weekend_cell.tscn")

@onready var cell_grid_container: GridContainer = %CellGridContainer

func _ready() -> void:
    call_deferred("populate_cells")

func populate_cells() -> void:
    for child in cell_grid_container.get_children():
        cell_grid_container.remove_child(child)
        child.queue_free()

    for day in range(28):
        var cell_instance: PanelContainer = null
        if day % 7 in [5, 6]: # Saturday or Sunday
            cell_instance = weekend_cell_scene.instantiate()
        else:
            cell_instance = weekday_cell_scene.instantiate()
        cell_instance.day = day + 1
        cell_instance.size_flags_horizontal = PanelContainer.SIZE_EXPAND_FILL
        cell_instance.size_flags_vertical = PanelContainer.SIZE_EXPAND_FILL

        cell_grid_container.add_child(cell_instance)