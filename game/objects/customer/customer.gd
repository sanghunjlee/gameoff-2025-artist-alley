extends CharacterBody2D
class_name Customer

enum CustomerState {
    WALKING_TO_BOOTH,
    LOOKING_AT_BOOTH,
    WALKING_TO_EXIT
}

const CUSTOMER_VISIT_DURATION_RANGE = Vector2(1.0, 3.0) # seconds
const CHANCE_OF_CUSTOMER_VISITING_BOOTH = 0.5

@export var emote_component: EmoteComponent
@export var movement_speed: float = 4.0
@export var time_to_spend_at_booth_timer: Timer
@export var time_to_notice_booth_timer: Timer
@export var animated_sprite: AnimatedSprite2D
@export var navigation_agent: NavigationAgent2D
@onready var customer_data: CustomerResource
@onready var exit_position: Vector2
@onready var booth_position: Vector2
@onready var customer_state: CustomerState = CustomerState.WALKING_TO_EXIT
var has_stopped_at_booth = false # To prevent multiple stops
# When spawned, type should be set by convention scene script

func _ready() -> void:
    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
    navigation_agent.connect("navigation_finished", Callable(self, "_on_navigation_finished"))
    

func _physics_process(delta):
    # Do not query when the map has never synchronized and is empty.
    if navigation_agent.is_navigation_finished():
        return

    var next_path_position: Vector2 = navigation_agent.get_next_path_position()
    var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
    if navigation_agent.avoidance_enabled:
        navigation_agent.set_velocity(new_velocity)
    else:
        _on_velocity_computed(new_velocity)

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

func walk_to_position(_target_position: Vector2) -> void:
    animated_sprite.play()
    navigation_agent.target_position = _target_position

    if _target_position.x > global_position.x:
        animated_sprite.flip_h = true
    else:
        animated_sprite.flip_h = false

func _on_velocity_computed(suggested_velocity: Vector2) -> void:
    velocity = suggested_velocity
    move_and_slide()

# After having looked at booth
func _on_time_to_spend_at_booth_timer_timeout() -> void:
    var has_bought = MerchManager.purchase_random_merch_by_design_types(customer_data.liked_design_types)
    if has_bought:
        emote_component.play_emote("happy")
    else:
        emote_component.play_emote("sad")
    walk_to_position(exit_position)
    customer_state = CustomerState.WALKING_TO_EXIT

func _on_time_to_notice_booth_timer_timeout() -> void:
    if randf() < CHANCE_OF_CUSTOMER_VISITING_BOOTH and not has_stopped_at_booth:
        walk_to_booth()

func walk_to_booth() -> void:
    customer_state = CustomerState.WALKING_TO_BOOTH
    emote_component.play_emote("exclaim")
    walk_to_position(booth_position)
    await navigation_agent.target_reached
    look_at_booth()

func stop_walking() -> void:
    navigation_agent.target_position = global_position
    velocity = Vector2.ZERO
    move_and_slide()

    # update animation
    animated_sprite.frame = 0
    animated_sprite.stop()

func look_at_booth() -> void:
    customer_state = CustomerState.LOOKING_AT_BOOTH
    has_stopped_at_booth = true
    stop_walking()
    
    time_to_spend_at_booth_timer.wait_time = randf_range(CUSTOMER_VISIT_DURATION_RANGE.x, CUSTOMER_VISIT_DURATION_RANGE.y)
    time_to_spend_at_booth_timer.start()

func _on_navigation_finished() -> void:
    if customer_state == CustomerState.WALKING_TO_EXIT:
        CustomerManager.emit_signal("customer_exited")
