extends Control


func _on_get_inspiration_button_pressed():
    GameState.inspiration_point += randi_range(1, 5)

func _on_sleep_button_pressed() -> void:
    StatsManager.handle_task_action(GameState.PlayerTaskType.SLEEP)

func _on_tv_button_pressed() -> void:
    StatsManager.handle_task_action(GameState.PlayerTaskType.WATCH_TV)

func _on_pc_button_pressed() -> void:
    StatsManager.handle_task_action(GameState.PlayerTaskType.USE_PC)

func _on_draw_button_pressed() -> void:
    StatsManager.handle_task_action(GameState.PlayerTaskType.DRAW)
