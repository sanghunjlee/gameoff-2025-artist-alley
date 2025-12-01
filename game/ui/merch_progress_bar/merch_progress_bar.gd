extends Control

var is_merch_processing = false

@onready var progress_bar = $TextureProgressBar

func _ready() -> void:
    self.visible = false

    MerchManager.merch_started.connect(on_merch_start)
    MerchManager.merch_completed.connect(on_merch_completed)
    MerchManager.merch_canceled.connect(on_merch_canceled)

    if MerchManager.current_order != null:
        on_merch_start(MerchManager.current_order.order)

func _process(_delta: float) -> void:
    if is_merch_processing:
        if progress_bar and MerchManager.current_order != null:
            progress_bar.value = MerchManager.current_order.order.process_time - MerchManager.wait_time

func on_merch_start(merch: MerchStackResource):
    if progress_bar:
        progress_bar.max_value = merch.process_time
        progress_bar.value = 0.0
        
    self.is_merch_processing = true
    self.visible = true

func on_merch_completed(merch: MerchStackResource):
    if progress_bar:
        progress_bar.value = merch.process_time

    self.is_merch_processing = false
    self.visible = false

func on_merch_canceled():
    self.is_merch_processing = false
    self.visible = false
