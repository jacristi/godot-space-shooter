class_name Enemy
extends Node2D

@onready var move_component:  MoveComponent  = $MoveComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var score_component: ScoreComponent = $ScoreComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component:  HitboxComponent  = $HitboxComponent
@onready var destroyed_component: DestroyedComponent = $DestroyedComponent
@onready var audio_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var energy_spawner_component: SpawnerComponent = $EnergySpawnerComponent

@export var spawn_time := 30.0
@export var energy_dropped := 1

var is_destroyed := false

func _ready() -> void:
    stats_component.no_health.connect(handle_destroyed)
    visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
    hurtbox_component.hurt.connect(was_hurt)
    hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))


func was_hurt(_hitbox: HitboxComponent) -> void:
    flash_component.flash()
    scale_component.tween_scale()
    shake_component.tween_shake()
    audio_player.play_with_variance()


func handle_destroyed() -> void:
    if is_destroyed: return
    is_destroyed = true

    for i in range(randf_range(0, energy_dropped+1)):
        energy_spawner_component.spawn()

    score_component.adjust_score()
