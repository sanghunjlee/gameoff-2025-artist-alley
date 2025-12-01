class_name InGameDateTime extends Resource

@export var year: int
@export var month: int
@export var day: int

func _init(y: int, m: int, d: int) -> void:
    year = y
    month = m
    day = d