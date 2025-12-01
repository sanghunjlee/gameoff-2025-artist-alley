class_name Convention extends Node2D
# Control convention scene elements
# Eg. Spawn customers, transition scene upon con closing

const CUSTOMER_SPAWN_DELAY_RANGE = Vector2(0.1, .5) # seconds

@export var TOTAL_CUSTOMERS_TO_SPAWN = 1

# @export var convention_resource: ConventionResource

@export var convention_dialogue: DialogueResource
@export var customers_node: Node
@export var customer_spawn_timer: Timer
@export var customer_scene: PackedScene
@export var customer_resource_loader: CustomerResourceLoader
@export var booth_area: Area2D

@export var customer_bound_left: Area2D
@export var customer_bound_right: Area2D

@onready var customers_spawned = 0
@onready var customers_exited = 0:
    set(value):
        customers_exited = value
        if customers_exited >= TOTAL_CUSTOMERS_TO_SPAWN:
            end_convention()

func _ready():
    CustomerManager.connect("customer_exited", Callable(self, "_on_customer_exited"))
    customer_spawn_timer.wait_time = randf_range(CUSTOMER_SPAWN_DELAY_RANGE.x, CUSTOMER_SPAWN_DELAY_RANGE.y)
    customer_spawn_timer.start()

func spawn_random_customer() -> void:
    # note: had a hard time implementing this cleanly cus of resource sharing issues and reliance on data for sprite initialization
    # would be nice to have a structured way for customers to initialize themselves based on their data
    var customer = customer_scene.instantiate()
    customer.customer_data = customer_resource_loader.get_random_customer_data()
    customer.set_sprite_from_data()
    customers_spawned += 1
    customer.booth_position = get_random_point_in_area(booth_area)

    # Have customer spawn on either the left or right bound at a random y position within the bound's shape
    var bound = [customer_bound_left, customer_bound_right].pick_random()
    customer.global_position = get_random_point_in_area(bound)
    
    # If customer spawns on left, flip sprite to face right and set exit as opposite bound
    if bound == customer_bound_left:
        customer.exit_position = get_random_point_in_area(customer_bound_right)
    else:
        customer.exit_position = get_random_point_in_area(customer_bound_left)
    
    customer.walk_to_position(customer.exit_position)
    customers_node.add_child(customer)

func _on_customer_spawn_timer_timeout() -> void:
    if customers_spawned < TOTAL_CUSTOMERS_TO_SPAWN:
        spawn_random_customer()

func get_random_point_in_area(area: Area2D) -> Vector2:
    var collision_shape = area.get_node("CollisionShape2D") as CollisionShape2D
    var rect = collision_shape.shape.get_rect()
    var random_x = randf_range(rect.position.x, rect.position.x + rect.size.x)
    var random_y = randf_range(rect.position.y, rect.position.y + rect.size.y)
    return area.global_position + Vector2(random_x, random_y)

func _on_customer_exited() -> void:
    customers_exited += 1

func end_convention() -> void:
    print_debug("Convention ended, all customers have exited.")
    DialogueManager.show_dialogue_balloon(convention_dialogue, "end_convention")
    await DialogueManager.dialogue_ended
    TimeManager.pass_day()
    SceneManager.change_scene_to(SceneManager.main_scene)
