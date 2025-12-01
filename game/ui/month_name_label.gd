class_name MonthNameLabel extends Label

@export var is_short_name: bool = false 

func _ready():
    TimeManager.time_updated.connect(update_text)
    update_text()

func update_text():
    var month_names = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "October",
        "September",
        "November",
        "December"
    ]

    var current_month_index = TimeManager.get_current_month()
    var current_month_name: String = month_names[current_month_index]

    if is_short_name:
        current_month_name = current_month_name.left(3)
    
    text = current_month_name