extends Node2D
class_name BedroomScene

const OBJECT_OFF = 0
const OBJECT_ON = 1

# Bedroom sprites
# example path: Sprites/Rug (animatedsprite2d)
@export var window_sprite: AnimatedSprite2D
@export var bed_sprite: AnimatedSprite2D
@export var tv_sprite: AnimatedSprite2D
@export var pc_sprite: AnimatedSprite2D
@export var desk_sprite: AnimatedSprite2D
@export var books_sprite: AnimatedSprite2D
@export var closet_sprite: AnimatedSprite2D
@export var door_sprite: AnimatedSprite2D

# Where the player stands when performing a task
@onready var bed_position: Vector2 = $Markers/Bed.position
@onready var desk_position: Vector2 = $Markers/Desk.position
@onready var main_door_position: Vector2 = $Markers/Door.position
@onready var closet_door_position: Vector2 = $Markers/Closet.position
@onready var books_position: Vector2 = $Markers/Books.position
@onready var tv_position: Vector2 = $Markers/TV.position
@onready var pc_position: Vector2 = $Markers/PC.position

func _ready() -> void:
    TimeManager.time_updated.connect(update_window)

func turn_on_object(sprite: AnimatedSprite2D) -> void:
    sprite.frame = OBJECT_ON

func turn_off_object(sprite: AnimatedSprite2D) -> void:
    sprite.frame = OBJECT_OFF

func turn_off_everything() -> void:
    turn_off_object(tv_sprite)
    turn_off_object(pc_sprite)
    turn_off_object(desk_sprite)

func update_window() -> void:
    window_sprite.play("window_" + TimeManager.get_current_daytime())