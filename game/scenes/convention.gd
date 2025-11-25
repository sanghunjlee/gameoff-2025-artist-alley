class_name Convention extends Node2D
# Control convention scene elements
# Eg. Spawn customers, transition scene upon con closing
const CUSTOMER_SPAWN_DELAY_RANGE = Vector2(0.1, .5) # seconds
@export var TOTAL_CUSTOMERS_TO_SPAWN = 50


# @export var convention_resource: ConventionResource

@export var customer_spawn_timer: Timer
@export var customer_scene: PackedScene
@export var customer_resource_loader: CustomerResourceLoader

@onready var customer_bound_left_shape = %LeftShape
@onready var customer_bound_right_shape = %RightShape

@onready var customers_spawned = 0

func _ready():
    customer_spawn_timer.wait_time = randf_range(CUSTOMER_SPAWN_DELAY_RANGE.x, CUSTOMER_SPAWN_DELAY_RANGE.y)
    customer_spawn_timer.start()

func spawn_random_customer() -> void:
    # note: had a hard time implementing this cleanly cus of resource sharing issues and reliance on data for sprite initialization
    # would be nice to have a structured way for customers to initialize themselves based on their data
    var customer = customer_scene.instantiate()
    customer.customer_data = customer_resource_loader.get_random_customer_data()
    customer.set_sprite_from_data()
    customers_spawned += 1

    # Have customer spawn on either the left or right bound at a random y position within the bound's shape
    customer.global_position = Vector2(
        [
            customer_bound_left_shape.global_position.x,
            customer_bound_right_shape.global_position.x
        ].pick_random(),
        randf_range(
            customer_bound_left_shape.shape.get_rect().position.y,
            customer_bound_left_shape.shape.get_rect().position.y + customer_bound_left_shape.shape.get_rect().size.y
        )
    )

    # If customer spawns on left, flip sprite to face right
    if customer.global_position.x == customer_bound_left_shape.global_position.x:
        customer.start_walk(Vector2.RIGHT)
    else:
        customer.start_walk(Vector2.LEFT)

    add_child(customer)
    print_debug("Spawning customer of type: %s" % customer.customer_data.customer_type_name)
    
func _on_customer_spawn_timer_timeout() -> void:
    if customers_spawned < TOTAL_CUSTOMERS_TO_SPAWN:
        spawn_random_customer()
