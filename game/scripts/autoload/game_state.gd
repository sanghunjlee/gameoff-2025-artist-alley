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

const INITIAL_MONEY: int = 100
const INITIAL_INSPIRATION_LEVEL: int = 0
const INITIAL_INSPIRATION_POINT: int = 0
const INITIAL_TIME_COUNT: int = 0

# Time control state
var time_state: TimeControlState = TimeControlState.PLAY:
    set(value):
        if value != time_state:
            time_state = value
            TimeManager.emit_signal("time_control_updated")

# eg. main, title, game_over, convention...
var scenes_data: ScenesData = preload("res://game/resources/scenes/ScenesData.tres")
var current_scene: PackedScene = scenes_data.initial_scene

# Easier check for pause state
var is_paused: bool:
    get():
        return time_state == TimeControlState.PAUSE or time_state == TimeControlState.FORCE_PAUSE
    set(value):
        push_error("Cannot set is_paused directly. Use time_state instead.")

## Currency Items
# Inspiration
# TODO: implement "insp calc funcs" to handle calculations related to inspiration level, point, limit
var inspiration_level: int = INITIAL_INSPIRATION_LEVEL
var inspiration_point: int = INITIAL_INSPIRATION_POINT:
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

@onready var money = INITIAL_MONEY:
    set(value): # On money change, emit signal to update money UI
        if money != value:
            money = value
            StatsManager.emit_signal("money_updated")
        if money <= 0:
            money = 0
            StatsManager.emit_signal("money_depleted")

@onready var time_count = INITIAL_TIME_COUNT: # Used by TimeManager:
    set(value): # On time_count change, emit signal to update time UI
        if time_count != value:
            time_count = value
            TimeManager.emit_signal("time_updated")

func get_money() -> int:
    return money
