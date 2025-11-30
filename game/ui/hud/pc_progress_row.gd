extends HBoxContainer

@export var task_id: int = -1
@export var task: MerchStackResource
@export var is_current: bool = false


@onready var id_label: Label = %IdLabel
@onready var title_label: Label = %TitleLabel
@onready var progress_bar: TextureProgressBar = $TextureProgressBar

func _ready() -> void:
    update_ui()

func _process(_delta: float) -> void:
    if task == null:
        return

    if is_current and MerchManager.current_work != null:
        progress_bar.value = MerchManager.current_work.process_time - MerchManager.wait_time

func update_ui() -> void:
    if task == null:
        return

    id_label.text = str(task_id)
    title_label.text = "%s x%d" % [task.merch, task.amount]

    if is_current:
        progress_bar.visible = true
        progress_bar.max_value = task.process_time
        progress_bar.value = MerchManager.current_work.process_time - MerchManager.wait_time
    else:
        progress_bar.visible = false

func _on_cancel_button_pressed():
    MerchManager.cancel_merch(task_id)

