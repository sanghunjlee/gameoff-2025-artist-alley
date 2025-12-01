extends Node2D
class_name BedroomScene

const OBJECT_OFF = 0
const OBJECT_ON = 1

# Bedroom sprites
# example path: Sprites/Rug (animatedsprite2d)
@onready var window_sprite: AnimatedSprite2D = $Sprites/Window
@onready var bed_sprite: AnimatedSprite2D = $Sprites/Bed
@onready var tv_sprite: AnimatedSprite2D = $Sprites/TV
@onready var pc_sprite: AnimatedSprite2D = $Sprites/PC
@onready var desk_sprite: AnimatedSprite2D = $Sprites/Desk
@onready var books_sprite: AnimatedSprite2D = $Sprites/Books
@onready var closet_sprite: AnimatedSprite2D = $Sprites/ClosetDoor
@onready var door_sprite: AnimatedSprite2D = $Sprites/MainDoor

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
    sprite.animation = "in_use"
    sprite.play()

func turn_off_object(sprite: AnimatedSprite2D) -> void:
    sprite.animation = "not_in_use"

func turn_off_everything() -> void:
    for sprite in $Sprites.get_children():
        if sprite is AnimatedSprite2D:
            if sprite.sprite_frames.has_animation("in_use"):
                turn_off_object(sprite)

func update_window() -> void:
    window_sprite.play(TimeManager.get_current_daytime())
