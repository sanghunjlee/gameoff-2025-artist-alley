extends Control



func _on_get_inspiration_button_pressed():
    GameState.inspiration_point += randi_range(1, 5)

func _on_make_merch_button_pressed():
    pass # Replace with function body.
