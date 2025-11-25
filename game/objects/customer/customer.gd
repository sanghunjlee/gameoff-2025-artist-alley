extends CharacterBody2D
class_name Customer

@export var animated_sprite: AnimatedSprite2D

@onready var customer_data: CustomerResource

# When spawned, type should be set by convention scene script
# func _ready():
#     #customer_data = GameState.get_customer_data(customer_type)
#     _set_sprite_from_data()

func _process(delta: float) -> void:
    move_and_slide()

func set_sprite_from_data() -> void:
    # Create a new unique SpriteFrames resource for this customer
    var sprite_frames = SpriteFrames.new()
    sprite_frames.add_animation("walk")
    
    var texture = customer_data.sprite_sheet
    var frame_width = 16
    var frame_height = 16

    for i in range(texture.get_region().size.x / frame_width):
        var frame = AtlasTexture.new()
        frame.atlas = texture.atlas
        frame.region = Rect2(
            texture.get_region().position + Vector2(i * frame_width, 0),
            Vector2(frame_width, frame_height)
        )
        sprite_frames.add_frame("walk", frame)

    # Assign the unique SpriteFrames to this customer's AnimatedSprite2D
    animated_sprite.sprite_frames = sprite_frames
    animated_sprite.play()

func start_walk(direction=Vector2.LEFT) -> void:
    match direction:
        Vector2.LEFT:
            animated_sprite.flip_h = false
        Vector2.RIGHT:
            animated_sprite.flip_h = true
    velocity = direction.normalized() * 50
