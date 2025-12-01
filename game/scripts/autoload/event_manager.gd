extends Node

var rent_due_dialogue = preload("res://game/dialogue/rent_due_dialogue.dialogue")

func _ready() -> void:
    TimeManager.connect("time_updated", Callable(self, "_on_time_updated"))

func _on_time_updated() -> void:
    if TimeManager.get_current_day() == GameState.RENT_DUE_DAY and !GameState.is_rent_collected:
        # Every month (on the day specified by RENT_DUE_DAY const)
        do_rent_collection_day()

    elif TimeManager.get_current_day() == GameState.RENT_DUE_DAY + 1 and GameState.is_rent_collected:
        GameState.is_rent_collected = false

    elif TimeManager.get_current_day() % 7 == 0 and GameState.current_scene == GameState.scenes_data.main_scene:
        go_to_convention()

func go_to_convention() -> void:
    TimeManager.force_pause_time()
    StatsManager.handle_task_action(GameState.PlayerTaskType.NONE, true)
    SceneManager.change_scene_to(SceneManager.convention_scene)

func go_to_game_over() -> void:
    TimeManager.force_pause_time()
    StatsManager.handle_task_action(GameState.PlayerTaskType.NONE, true)
    SceneManager.change_scene_to(SceneManager.game_over_scene)

func do_rent_collection_day() -> void:
    # Rent payment is handled within the dialogue
    TimeManager.force_pause_time()
    DialogueManager.show_dialogue_balloon(rent_due_dialogue, "start")
    await DialogueManager.dialogue_ended

    if GameState.money >= GameState.rent_amount:
        DialogueManager.show_dialogue_balloon(rent_due_dialogue, "pay_rent", [self])
        await DialogueManager.dialogue_ended
        GameState.is_rent_collected = true
        TimeManager.play_time()
        StatsManager.handle_task_action(GameState.PlayerTaskType.NONE) # Reset task since you are rudely awoken

    else:
        DialogueManager.show_dialogue_balloon(rent_due_dialogue, "cant_pay_rent")
        await DialogueManager.dialogue_ended
        go_to_game_over()
