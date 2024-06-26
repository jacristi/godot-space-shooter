extends Node2D

@onready var duration_timer: Timer = $DurationTimer
@onready var flash_component: FlashComponent = $FlashComponent
@onready var flash_timer: Timer = $FlashTimer

@onready var shield_up_audio: AudioStreamPlayer = $ShieldUpAudio
@onready var shield_down_audio: AudioStreamPlayer = $ShieldDownAudio


var is_flashing := false

func _ready():
    duration_timer.timeout.connect(
        dissipate_shield
    )
    shield_up_audio.play()


func _process(_delta: float) -> void:
    if duration_timer.time_left <= 3.25:
        set_flash_continuous()


func dissipate_shield():
    queue_free()


func set_flash_continuous() -> void:
    if is_flashing == true:
        return
    is_flashing = true
    flash_timer.process_mode = Node.PROCESS_MODE_INHERIT
    flash_timer.timeout.connect(warn_end_of_life)
    flash_timer.start()


func warn_end_of_life() -> void:
    flash_component.flash()
    shield_down_audio.play()
