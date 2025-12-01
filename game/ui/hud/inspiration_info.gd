extends Control

@onready var progress_bar = %InspirationBar
@onready var inspiration_label = %InspirationLabel

func _ready():
    StatsManager.inspiration_updated.connect(_on_inspiration_updated)
    update_ui()

func update_ui():
    progress_bar.value = (100.0 * GameState.inspiration_point) / GameState.inspiration_limit
    inspiration_label.text = str(int(GameState.inspiration_point)) + "/" + str(int(GameState.inspiration_limit))


func _on_inspiration_updated():
    update_ui()