extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_play_button_mouse_exited() -> void:
    $BackgroundDefault.visible = true

func _on_play_button_mouse_entered() -> void:
    $BackgroundDefault.visible = false


func _on_play_button_pressed() -> void:
    SceneManager.change_scene_to(GameState.scenes_data.main_scene)
