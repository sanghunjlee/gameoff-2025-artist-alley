extends Control

@onready var bubble_text: String = "sample text"

func _ready() -> void:
    %Label.text = bubble_text