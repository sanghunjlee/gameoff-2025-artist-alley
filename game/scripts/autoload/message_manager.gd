extends Node
# Uses DialogueManager
@onready var my_resource = preload("res://dialogue/my_dialogue.dialogue")

func _ready() -> void:
    print_debug("MessageManager ready, starting dialogue...")
    start_dialogue()

func start_dialogue() -> void:
    DialogueManager.show_dialogue_balloon(my_resource, "start")
