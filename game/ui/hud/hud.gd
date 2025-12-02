extends Node

@export var current_tab: int = 0:
    set(value):
        current_tab = value
        _update_tab_visibility()

@onready var home_tab: Control = %HomeTab
@onready var inventory_tab: Control = %InventoryTab
@onready var calendar_tab: Control = %CalendarTab

@onready var sleep_timer = $SleepTimer
@onready var sleep_countdown_label = $SleepCountdownLabel
@onready var sleep_count = 5

func _ready():
    StatsManager.connect("player_exited_bed", Callable(self, "_on_player_exited_bed"))
    sleep_timer.timeout.connect(_on_sleep_timer_timeout)
    StatsManager.connect("player_laid_in_bed", Callable(self, "_on_player_laid_in_bed"))
    self.visible = true
    _update_tab_visibility()

func _update_tab_visibility() -> void:
    self.visible = true
    home_tab.visible = current_tab == 0
    calendar_tab.visible = current_tab == 1
    inventory_tab.visible = current_tab == 2

func _on_home_tab_selected() -> void:
    current_tab = 0

func _on_calendar_tab_selected() -> void:
    current_tab = 1

func _on_inventory_tab_selected() -> void:
    current_tab = 2

func _on_sleep_timer_timeout() -> void:
    sleep_count -= 1
    sleep_countdown_label.text = "Going the convention in " + str(sleep_count) + " seconds..."
    sleep_timer.start()
    if sleep_count <= 0:
        sleep_timer.stop()
        sleep_countdown_label.visible = false
        sleep_count = 5
        print_debug("Sleep timer ended, emitting skip to convention signal.")
        StatsManager.emit_signal("skip_to_convention")
    

func _on_player_laid_in_bed() -> void:
    sleep_countdown_label.visible = true
    sleep_countdown_label.text = "Going the convention in " + str(sleep_count) + " seconds..."
    sleep_timer.start()
    print_debug("starting sleep timer.")

func _on_player_exited_bed() -> void:
    sleep_timer.stop()
    sleep_countdown_label.visible = false
    sleep_count = 5
    print_debug("player exited bed, stopping sleep timer.")
