extends CharacterBody2D
class_name Player

# Represents the player character in the game world
# Given a task to perform, player will navigate within BedroomScene's
# NavigationRegion2D using its specified task position variables
# and perform an interact animation for a specified duration until a signal is heard
# Note that the character is not manually controlled via input, but automatically
# moves in the world according to its assigned task

signal task_left(task: GameState.PlayerTaskType) # Should emit when task abandoned or finished

# task positions can be accessed via bedroom_scene.<task>_position
@export var bedroom_scene: BedroomScene
@export var speed: float = 100.0
@export var starting_task: GameState.PlayerTaskType = GameState.PlayerTaskType.NONE
@export var message_bubble: OverheadSpeechBubble

@onready var current_task: GameState.PlayerTaskType = GameState.PlayerTaskType.NONE:
    set(_current_task):
        if current_task != GameState.PlayerTaskType.NONE:
            emit_signal("task_left", current_task)
        
        current_task = _current_task
        
        
@onready var is_interacting: bool = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
    GameState.player = self

    connect("task_left", Callable(self, "_on_task_left"))
    navigation_agent.connect("navigation_finished", Callable(self, "_on_navigation_finished"))

    navigation_agent.max_speed = speed
    navigation_agent.target_desired_distance = 3.0

    do_task(starting_task)

    message_bubble.show_message("Good meowning!")

func _physics_process(delta: float) -> void:
    if !navigation_agent.is_navigation_finished():
        move_toward_target(delta)
    else:
        velocity = Vector2.ZERO

func move_toward_target(_delta):
    var next_position = navigation_agent.get_next_path_position()
    var direction = (next_position - global_position).normalized()

    var adjusted_speed = speed
    if GameState.is_paused:
        adjusted_speed = 0.0
    elif GameState.time_state == GameState.TimeControlState.FAST:
        adjusted_speed *= TimeManager.fast_forward_multiplier
        
    velocity = direction * adjusted_speed
    move_and_slide()

func do_task(task: GameState.PlayerTaskType) -> void:
    if task != current_task:
        current_task = task
        
        var target_position: Vector2
        var task_sprite: AnimatedSprite2D

        match task:
            GameState.PlayerTaskType.DRAW:
                message_bubble.show_message("What to draw...?")
                target_position = bedroom_scene.desk_position

            GameState.PlayerTaskType.WATCH_TV:
                message_bubble.show_message("Let's watch some TV!")
                target_position = bedroom_scene.tv_position
                
            GameState.PlayerTaskType.USE_PC:
                message_bubble.show_message("Computer-ing time!")
                target_position = bedroom_scene.pc_position

            GameState.PlayerTaskType.SLEEP:
                message_bubble.show_message("Yawn...")
                target_position = bedroom_scene.bed_position
            _:
                return # Invalid task

        navigation_agent.target_position = target_position

# Reset sprites to initial default state
func reset_sprites() -> void:
    # Reset any bedroom sprites that may have changed during tasks
    bedroom_scene.turn_off_everything()
    visible = true

func complain() -> void:
    match current_task:
        GameState.PlayerTaskType.DRAW:
            message_bubble.show_message("I have no inspiration.")
        GameState.PlayerTaskType.WATCH_TV:
            message_bubble.show_message("This show is so boring.")
        GameState.PlayerTaskType.USE_PC:
            message_bubble.show_message("I don't have enough money.")
        GameState.PlayerTaskType.SLEEP:
            message_bubble.show_message("I am too eepy.")


func _on_task_left(current_task: GameState.PlayerTaskType) -> void:
    is_interacting = false
    reset_sprites()

# Upon task reached successfully by navigation agent
func _on_navigation_finished() -> void:
    is_interacting = true
    AudioManager.play_sound(AudioManager.audio_resource.beep_sfx)
    # Face appropriate direction based on task
    match current_task:
        GameState.PlayerTaskType.DRAW:
            animated_sprite.play("sit_right")
        GameState.PlayerTaskType.WATCH_TV:
            animated_sprite.play("sit_up")
        GameState.PlayerTaskType.USE_PC:
            animated_sprite.play("sit_up")
        GameState.PlayerTaskType.SLEEP:
            animated_sprite.face_direction("down")
    print_debug(animated_sprite.is_playing())

    # Activate bedroom object based on task
    match current_task:
        GameState.PlayerTaskType.DRAW:
            bedroom_scene.turn_on_object(bedroom_scene.desk_sprite)
        GameState.PlayerTaskType.WATCH_TV:
            bedroom_scene.turn_on_object(bedroom_scene.tv_sprite)
        GameState.PlayerTaskType.USE_PC:
            bedroom_scene.turn_on_object(bedroom_scene.pc_sprite)
        GameState.PlayerTaskType.SLEEP:
            bedroom_scene.turn_on_object(bedroom_scene.bed_sprite)
            visible = false # Hide player when sleeping
