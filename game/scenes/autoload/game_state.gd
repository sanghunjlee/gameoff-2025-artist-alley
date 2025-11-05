extends Node

# Pause state
var is_paused: bool = false

# Stat vars
@onready var player_name = "ARTIST"
@onready var money = 0:
    set(value): # On money change, emit signal to update money UI
        if money != value:
            money = value
            StatsManager.emit_signal("money_updated")
@onready var inventory = []
@onready var time_count = 0: # Used by TimeManager:
    set(value): # On time_count change, emit signal to update time UI
        if time_count != value:
            time_count = value
            TimeManager.emit_signal("time_updated")
