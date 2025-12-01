extends Node

var is_rent_collected: bool = false
var rent_due_dialogue = preload("res://game/dialogue/rent_due_dialogue.dialogue")

func _ready() -> void:
    TimeManager.connect("time_updated", Callable(self, "_on_time_updated"))

func _on_time_updated() -> void:
    if TimeManager.get_current_day() == GameState.RENT_DUE_DAY and !is_rent_collected:
        # Every month (on the day specified by RENT_DUE_DAY const)
        do_rent_collection_day()

    elif TimeManager.get_current_day() == GameState.RENT_DUE_DAY + 1 and is_rent_collected:
        is_rent_collected = false

    elif TimeManager.get_current_day() % 7 == 0 and GameState.current_scene == GameState.scenes_data.main_scene:
        go_to_convention()

func go_to_convention() -> void:
    TimeManager.force_pause_time()
    StatsManager.handle_task_action(GameState.PlayerTaskType.NONE)
    SceneManager.change_scene_to(SceneManager.convention_scene)

func go_to_game_over() -> void:
    SceneManager.change_scene_to(SceneManager.game_over_scene)

func do_rent_collection_day() -> void:
    TimeManager.force_pause_time()
    if GameState.money >= GameState.rent_amount:
        StatsManager.spend_money(GameState.rent_amount)
        MessageLogManager.append_log("You paid $:" + str(GameState.rent_amount) + " for your apartment")
        is_rent_collected = true
        TimeManager.play_time()
    else:
        DialogueManager.show_dialogue_balloon(rent_due_dialogue, "cant_pay")
        await DialogueManager.dialogue_ended
        go_to_game_over()
