extends Control

@onready var merch_order_form: Control = %MerchOrderForm
@onready var progress_window: Control = %ProgressWindow

func _ready():
    visible = false
    StatsManager.task_changed.connect(_on_task_changed)

func close_window() -> void:
    visible = false
    TimeManager.play_time()
    StatsManager.handle_task_action(GameState.PlayerTaskType.NONE)

func _on_task_changed():
    # Close any open PC screen when task changes
    if GameState.current_task != GameState.PlayerTaskType.USE_PC:
        visible = false
    
    if GameState.current_task == GameState.PlayerTaskType.USE_PC:
        visible = true
        TimeManager.force_pause_time()


func _on_order_button_pressed():
    merch_order_form.open_window()

func _on_progress_button_pressed():
    progress_window.open_window()

func _on_close_button_pressed():
    close_window()
