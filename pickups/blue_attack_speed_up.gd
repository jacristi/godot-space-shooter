extends Node2D

@export var player: Node2D
@onready var variable_pitch_audio_stream_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer


func _ready() -> void:
    if player == null:
        player = get_tree().get_first_node_in_group("player")

    player.incr_fire_rate()
    variable_pitch_audio_stream_player.play()
    await get_tree().create_timer(2.0).timeout
    queue_free()
