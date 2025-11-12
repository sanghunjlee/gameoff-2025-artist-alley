extends Control

@onready var progress_bar = $ProgressBar

func _ready():
    StatsManager.inspiration_updated.connect(_on_inspiration_updated)

func _on_inspiration_updated():
    progress_bar.value = (100.0 * GameState.inspiration_point) / GameState.inspiration_limit