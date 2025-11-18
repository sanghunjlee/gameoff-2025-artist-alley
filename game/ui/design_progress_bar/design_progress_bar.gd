extends Control

var is_design_processing = false

@onready var progress_bar = $TextureProgressBar

func _ready() -> void:
    self.visible = false

    DesignManager.design_started.connect(on_design_start)
    DesignManager.design_completed.connect(on_design_completed)


func _process(_delta: float) -> void:
    if is_design_processing:
        if progress_bar:
            progress_bar.value = DesignManager.current_work.process_time - DesignManager.wait_time

func on_design_start(design: DesignResource):
    if progress_bar:
        progress_bar.max_value = design.process_time
        progress_bar.value = 0.0
    
    self.is_design_processing = true
    self.visible = true

func on_design_completed(design: DesignResource):
    if progress_bar:
        progress_bar.value = design.process_time

    self.is_design_processing = false
    self.visible = false
