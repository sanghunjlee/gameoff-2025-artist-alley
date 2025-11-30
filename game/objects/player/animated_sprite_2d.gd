extends AnimatedSprite2D

@onready var player = get_parent() as Player

# Player velocity determines facing and walking animation or if player stands
# still (stay on first frame of corresponding directional anim)
func _process(_delta: float) -> void:
    var velocity = player.velocity

    # If player not currently doing a task interaction, update animation based on movement
    if !player.is_interacting:
        if velocity.x > 0:
            animation = "walk_right" if velocity.length() > 0 else "stay_right"
        elif velocity.x < 0:
            animation = "walk_left" if velocity.length() > 0 else "stay_left"
        elif velocity.y > 0:
            animation = "walk_down" if velocity.length() > 0 else "stay_down"
        elif velocity.y < 0:
            animation = "walk_up" if velocity.length() > 0 else "stay_up"

        if velocity.x != 0 and velocity.y != 0:
            #print_debug("velocity x: ", velocity.x, " velocity y: ", velocity.y)
            play()

func face_direction(direction: String) -> void:
    match direction:
        "up":
            animation = "stay_up"
        "down":
            animation = "stay_down"
        "left":
            animation = "stay_left"
        "right":
            animation = "stay_right"
    frame = 0
    stop()
