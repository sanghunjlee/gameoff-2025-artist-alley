extends Control

@onready var play_button: Button = %PlayButton
@onready var pause_button: Button = %PauseButton
@onready var fast_button: Button = %FastButton

func _ready():
    # Initiate button pressed state based on game state
    # In case of save / load
    match GameState.time_state:
        GameState.TimeControlState.PLAY:
            play_button.button_pressed = true
        GameState.TimeControlState.PAUSE:
            play_button.button_pressed = true
        GameState.TimeControlState.FAST:
            play_button.button_pressed = true

func _on_play_button_toggled(toggled_on: bool):
    if toggled_on:
        GameState.time_state = GameState.TimeControlState.PLAY

func _on_pause_button_toggled(toggled_on: bool):
    if toggled_on:
        GameState.time_state = GameState.TimeControlState.PAUSE
    
func _on_fast_button_toggled(toggled_on: bool):
    if toggled_on:
        GameState.time_state = GameState.TimeControlState.FAST