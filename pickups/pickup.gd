class_name Pickup
extends Node2D

@export var energy_dropped: int

@onready var move_component:  MoveComponent  = $MoveComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component:  HitboxComponent  = $HitboxComponent
@onready var destroyed_component: DestroyedComponent = $DestroyedComponent
@onready var collected_component: DestroyedComponent = $CollectedComponent
@onready var flash_timer: Timer = $FlashTimer

@onready var audio_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var blip_audio_stream_player: VariablePitchAudioStreamPlayer = $BlipAudioStreamPlayer
@onready var energy_spawner_component: SpawnerComponent = $EnergySpawnerComponent


func _ready() -> void:
    stats_component.no_health.connect(handle_on_death)
    visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
    hurtbox_component.hurt.connect(was_hurt)
    hitbox_component.hit_hurtbox.connect(handle_on_collect)
    flash_timer.timeout.connect(flash_component.flash)
    flash_timer.timeout.connect(blip_audio_stream_player.play)


func was_hurt(_hitbox: HitboxComponent) -> void:
    flash_component.flash()
    scale_component.tween_scale()
    shake_component.tween_shake()
    audio_player.play_with_variance()


func handle_on_death() -> void:
    for i in range(energy_dropped):
        energy_spawner_component.spawn()


func handle_on_collect(_hurtbox: HurtboxComponent) -> void:
    collected_component.destroy()
