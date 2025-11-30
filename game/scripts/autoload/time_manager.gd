# TimeManager.gd
extends Node

# Responsible for managing in-game time based on GameState.time_count
# Should handle conversion between time_count integer and
# hours and days for display purposes.
# For example, time_count = 0 -> Day 1, 0:00
#              time_count = 15 -> Day 1, 15:00
#              time_count = 24 -> Day 2, 0:00

signal time_updated(time_count) # Called outside of class when time_count changes

signal time_control_updated # Called when time state changes (e.g. play, pause, fast forward)

# Note: DAYTIME refers to the general time of day (morning, afternoon, evening, night)
# Denotes the hour thresholds for different times of day
var daytimes = {
    "morning": 6, # eg. Morning starts at 6:00
    "afternoon": 12,
    "evening": 18,
    "night": 21
}

var fast_forward_multiplier: float = 5.0

# In-game time updates every second with respect to delta
func _process(delta: float) -> void:
    if GameState.is_paused:
        return

    if GameState.time_state == GameState.TimeControlState.PLAY:
        GameState.time_count += delta
    elif GameState.time_state == GameState.TimeControlState.FAST:
        GameState.time_count += delta * fast_forward_multiplier

func play_time() -> void:
    GameState.time_state = GameState.TimeControlState.PLAY

func force_pause_time() -> void:
    GameState.time_state = GameState.TimeControlState.FORCE_PAUSE

func pass_hour() -> void:
    GameState.time_count += 1

func pass_day() -> void:
    GameState.time_count += 24

func get_current_day() -> int:
    return (GameState.time_count / 24) + 1

func get_current_hour() -> int:
    return int(GameState.time_count) % 24

# preserve decimals when returning current hour
func get_current_time() -> float:
    var hour = int(GameState.time_count) % 24
    var decimals = GameState.time_count - int(GameState.time_count)
    return hour + decimals

func get_current_daytime() -> String:
    var hour = get_current_hour()
    if hour >= daytimes["morning"] and hour < daytimes["afternoon"]:
        return "morning"
    elif hour >= daytimes["afternoon"] and hour < daytimes["evening"]:
        return "afternoon"
    elif hour >= daytimes["evening"] and hour < daytimes["night"]:
        return "evening"
    else:
        return "night"