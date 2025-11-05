extends Control

@export var DayLabel: Label
@export var TimeLabel: Label
@export var MoneyLabel: Label

func _ready() -> void:
    TimeManager.connect("time_updated", Callable(self, "update_day_and_time_labels"))
    StatsManager.connect("money_updated", Callable(self, "update_money_label"))

    update_day_and_time_labels()
    update_money_label()

# Update day/time UI elements
func update_day_and_time_labels():
    DayLabel.text = str(TimeManager.get_current_day())
    TimeLabel.text = str(TimeManager.get_current_hour()) + ":00"

# Update money UI element
func update_money_label():
    MoneyLabel.text = "$" + str(GameState.money)
