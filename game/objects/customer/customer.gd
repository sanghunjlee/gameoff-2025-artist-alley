extends CharacterBody2D
class_name Customer

@export var customer_data: CustomerResource
@export var animated_sprite: AnimatedSprite2D

func _ready():
    # populate animatedsprite2d.spriteframes with sliced customer_data.sprite_sheet
    var sprite_frames = animated_sprite.sprite_frames
    if not sprite_frames.has_animation("walk"):
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

    animated_sprite.play()
