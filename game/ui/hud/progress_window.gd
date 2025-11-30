extends Control

signal window_closed

var progress_row_scene: PackedScene = preload("res://game/ui/hud/pc_progress_row.tscn")

@onready var progress_container: VBoxContainer = %ProgressContainer

func _ready() -> void:
    MerchManager.merch_started.connect(update_ui)
    MerchManager.merch_completed.connect(update_ui)
    MerchManager.merch_canceled.connect(update_ui)

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
        row.task_id = 0
        row.task = MerchManager.current_work
        row.is_current = true
        progress_container.add_child(row)

    for task_id in range(1, MerchManager.merch_queue.size() + 1):
        var task = MerchManager.merch_queue[task_id - 1]
        var row = progress_row_scene.instantiate()
        row.task_id = task_id
        row.task = task
        row.is_current = false
        progress_container.add_child(row)
        
func _on_close_button_pressed():
    close_window()
