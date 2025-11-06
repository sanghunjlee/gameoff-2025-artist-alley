# TimeManager.gd
extends Node

# Responsible for managing in-game time based on GameState.time_count
# Should handle conversion between time_count integer and
# hours and days for display purposes.
# For example, time_count = 0 -> Day 1, 0:00
#              time_count = 15 -> Day 1, 15:00
#              time_count = 24 -> Day 2, 0:00

signal time_updated # Called outside of class when time_count changes

# In-game time updates every second with respect to delta
func _process(delta: float) -> void:
    if not GameState.is_paused:
        GameState.time_count += delta

func pass_hour() -> void:
    GameState.time_count += 1

func pass_day() -> void:
    GameState.time_count += 24

func get_current_day() -> int:
    return (GameState.time_count / 24) + 1

func get_current_hour() -> int:
    return int(GameState.time_count) % 24
