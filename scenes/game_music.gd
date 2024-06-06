extends AudioStreamPlayer


var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus   = AudioServer.get_bus_index("SFX")

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("mute_music"):
        AudioServer.set_bus_mute(
            music_bus,
            not AudioServer.is_bus_mute(music_bus)
            )

    if Input.is_action_just_pressed("mute_sound"):
        AudioServer.set_bus_mute(
            sfx_bus,
            not AudioServer.is_bus_mute(sfx_bus)
            )
