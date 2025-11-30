extends Node

@onready var audio_resource: AudioResource = preload("res://game/resources/audio/AudioResource.tres")

func play_sound(sound: AudioStream) -> void:
    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = sound
    audio_player.play()
    audio_player.finished.connect(Callable(audio_player, "queue_free"))