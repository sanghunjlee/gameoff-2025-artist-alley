extends Control

signal window_closed

var progress_row_scene: PackedScene = preload("res://game/ui/hud/pc_progress_row.tscn")

@onready var progress_container: VBoxContainer = %ProgressContainer

func _ready() -> void:
    MerchManager.merch_started.connect(_on_merch_update)
    MerchManager.merch_completed.connect(_on_merch_update)

    visible = false
    update_ui()

func open_window() -> void:
    visible = true
    update_ui()

func close_window() -> void:
    visible = false
    window_closed.emit()


func update_ui() -> void:
    print_debug("Updating progress window UI")

    if progress_container == null:
        return

    for child in progress_container.get_children():
        progress_container.remove_child(child)
        child.queue_free()

    if MerchManager.current_work != null:
        var row = progress_row_scene.instantiate()
        row.task = MerchManager.current_work
        row.is_current = true
        progress_container.add_child(row)

    for task in MerchManager.merch_queue:
        var row = progress_row_scene.instantiate()
        row.task = task
        row.is_current = false
        progress_container.add_child(row)
        
func _on_merch_update(_merch: MerchStackResource) -> void:
    update_ui()

func _on_close_button_pressed():
    close_window()
