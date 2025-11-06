extends Node

var main_scene_resource = preload("res://game/scenes/main.tscn")

@onready var home_tab = %Home
@onready var game_viewport = %Home/%GameViewport

func _ready() -> void:
    var main_scene = main_scene_resource.instantiate()
    if game_viewport:
        game_viewport.add_child(main_scene)
