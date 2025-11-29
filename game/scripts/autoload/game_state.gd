extends Node

enum TimeControlState {
    PLAY,
    PAUSE,
    FAST,
    FORCE_PAUSE # Non-user controlled time (e.g. during cutscenes)
}

enum PlayerTaskType {
    NONE,
    DRAW,
    WATCH_TV,
    USE_PC,
    SLEEP
}


# Time control state
var time_state: TimeControlState = TimeControlState.PLAY:
    set(value):
        if value != time_state:
            time_state = value
            TimeManager.emit_signal("time_control_updated")

# Easier check for pause state
var is_paused: bool:
    get():
        return time_state == TimeControlState.PAUSE or time_state == TimeControlState.FORCE_PAUSE
    set(value):
        push_error("Cannot set is_paused directly. Use time_state instead.")

## Currency Items
# Inspiration
# TODO: implement "insp calc funcs" to handle calculations related to inspiration level, point, limit
var inspiration_level: int = 0
var inspiration_point: int = 0:
    set(value):
        # TODO: Replaced this to utilize "insp calc funcs"
        # inspiration_point = value % inspiration_limit
        inspiration_point = value
        StatsManager.emit_signal("inspiration_updated")
var inspiration_limit: int = 100

## Task related vars
var current_task: PlayerTaskType = PlayerTaskType.NONE
var is_on_task = false

## Merch related vars
var merch_inventory: MerchInventory = preload("res://game/resources/inventories/merch_inventory.tres")

## Design related vars
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
