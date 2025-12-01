extends Node2D

@onready var money_label = $MoneyLabel

func _ready() -> void:
    StatsManager.connect("money_updated", Callable(self, "_on_money_updated"))

func do_float_animation(label) -> void:
    var float_tween = create_tween()
    float_tween.tween_property(label, "position:y", -50, 1.0).as_relative()
    float_tween.tween_property(label, "modulate:a", 0.0, 1.0)

func _on_money_updated(new_money: int, change: int) -> void:
    # if earned money and at convention, show floating +money text
    if change > 0 and GameState.current_scene == SceneManager.convention_scene:
        var new_money_label = money_label.duplicate() as Label
        new_money_label.text = "+$" + str(change)
        new_money_label.visible = true
        do_float_animation(new_money_label)
        get_parent().add_child(new_money_label)
        AudioManager.play_sound(AudioManager.audio_resource.beep_sfx)
