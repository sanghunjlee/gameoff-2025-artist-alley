extends Node2D
class_name BedroomScene
# Task positions
@onready var bed_position: Vector2 = $Markers/Bed.position
@onready var desk_position: Vector2 = $Markers/Desk.position
@onready var main_door_position: Vector2 = $Markers/Door.position
@onready var closet_door_position: Vector2 = $Markers/Closet.position
@onready var books_position: Vector2 = $Markers/Books.position
@onready var tv_position: Vector2 = $Markers/TV.position
@onready var pc_position: Vector2 = $Markers/PC.position
