extends Control

@onready var amount_display = %MoneyAmount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    StatsManager.connect("money_updated", _on_money_updated)
    amount_display.text = str(GameState.money)

func _on_money_updated(new_money: int, change: int) -> void:
    amount_display.text = str(new_money)