extends Node

enum TimeControlState {
    PLAY,
    PAUSE,
    FAST
}

# Time control state
var time_state: TimeControlState = TimeControlState.PLAY:
    set(value):
        if value != time_state:
            time_state = value
            TimeManager.emit_signal("time_control_updated")

# Pause state
var is_paused: bool = false

## Currency Items
# Inspiration
# TODO: implement "insp calc funcs" to handle calculations related to inspiration level, point, limit
var inspiration_level: int = 0
var inspiration_point: int = 0:
    set(value):
        # TODO: Replaced this to utilize "insp calc funcs"
        inspiration_point = value % inspiration_limit
        StatsManager.emit_signal("inspiration_updated")
var inspiration_limit: int = 10

var merch_inventory: MerchInventory = preload("res://game/resources/inventories/merch_inventory.tres")
var design_inventory: DesignInventory = preload("res://game/resources/inventories/design_inventory.tres")

# Node reference
@onready var player: Player = null

# Stat vars
@onready var player_name = "ARTIST"

@onready var money = 0:
    set(value): # On money change, emit signal to update money UI
        if money != value:
            money = value
            StatsManager.emit_signal("money_updated")
@onready var time_count = 0: # Used by TimeManager:
    set(value): # On time_count change, emit signal to update time UI
        if time_count != value:
            time_count = value
            TimeManager.emit_signal("time_updated")
