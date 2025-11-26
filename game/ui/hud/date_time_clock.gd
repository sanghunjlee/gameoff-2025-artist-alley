extends Control

enum {
    AM,
    PM
}

var ampm = AM
var tween: Tween = null

@onready var clock_base: TextureRect = %ClockBase
@onready var hour_hand: TextureRect = %HourHand
@onready var month_label: Label = %MonthLabel
@onready var date_label: Label = %DateLabel

@onready var play_button: TextureButton = %PlayButton
@onready var pause_button: TextureButton = %PauseButton
@onready var fast_button: TextureButton = %FastButton

func _ready():
    TimeManager.time_updated.connect(_on_time_updated)
    _on_time_updated()

    # Initiate button pressed state based on game state
    # In case of save / load
    match GameState.time_state:
        GameState.TimeControlState.PLAY:
            play_button.button_pressed = true
        GameState.TimeControlState.PAUSE:
            play_button.button_pressed = true
        GameState.TimeControlState.FAST:
            play_button.button_pressed = true

func _on_time_updated():
    var day: int = TimeManager.get_current_day()
    var hour: int = TimeManager.get_current_hour()
    var time: float = TimeManager.get_current_time()


    if date_label.text != str(day):
        date_label.text = str(day)
        await date_label.draw
    
    var r = (hour + (time - hour)) * PI / 12
    hour_hand.rotation = r
    
    
    ampm = AM if time < 12 else PM

func _on_play_button_toggled(toggled_on: bool):
    if toggled_on:
        GameState.time_state = GameState.TimeControlState.PLAY

func _on_pause_button_toggled(toggled_on: bool):
    if toggled_on:
        GameState.time_state = GameState.TimeControlState.PAUSE
    
func _on_fast_button_toggled(toggled_on: bool):
    if toggled_on:
        GameState.time_state = GameState.TimeControlState.FAST
