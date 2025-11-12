extends Control

enum {
    AM,
    PM
}

var ampm = AM
var tween: Tween = null

@onready var clock_base: TextureRect = %ClockBase
@onready var hour_hand: TextureRect = %HourHand
@onready var month_label: Label = %MonthLabel
@onready var date_label: Label = %DateLabel

func _ready():
    TimeManager.time_updated.connect(_on_time_updated)
    _on_time_updated()

func _on_time_updated():
    var day: int = TimeManager.get_current_day()
    var hour: int = TimeManager.get_current_hour()
    var time: float = TimeManager.get_current_time()


    if date_label.text != str(day):
        date_label.text = str(day)
        await date_label.draw
    
    var r = (hour + (time - hour)) * PI / 12
    hour_hand.rotation = r
    
    
    ampm = AM if time < 12 else PM
