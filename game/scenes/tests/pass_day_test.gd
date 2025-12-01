extends Node2D

@onready var day_spin_box: SpinBox = %DaySpinBox
@onready var time_spin_box: SpinBox = %TimeSpinBox



func _on_button_pressed():
    if day_spin_box == null:
        return

    if time_spin_box == null:
        return

    var day: int = int(day_spin_box.value)
    var time: float = time_spin_box.value

    TimeManager.pass_day(day, time)


func _on_button_2_pressed():
    var day = TimeManager.get_days_until_next_convention()
    var time: float = time_spin_box.value

    TimeManager.pass_day(day, time)

