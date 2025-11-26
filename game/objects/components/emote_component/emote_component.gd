extends AnimatedSprite2D
class_name EmoteComponent

@export var display_timer: Timer # time to display emote before disappearing

func _ready() -> void:
    visible = false

func play_emote(emote_name: String) -> void:
    visible = true
    if sprite_frames.has_animation(emote_name):
        animation = emote_name
        play()
    display_timer.start()

func _on_display_timer_timeout() -> void:
    stop()
    visible = false
