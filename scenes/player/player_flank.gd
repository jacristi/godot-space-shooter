extends Node2D

@export var lerp_offset_x := -5
@export var lerp_offset_y := 5

@onready var stats_component: StatsComponent = $StatsComponent
@onready var projectile_spawner: SpawnerComponent = $ProjectileSpawner
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var shoot_audio_player: VariablePitchAudioStreamPlayer = $ShootAudioStreamPlayer
@onready var lerp_component: LerpComponent = $LerpComponent
@onready var pickup_audio: VariablePitchAudioStreamPlayer = $PickupAudio

var player
var is_flank_left_1 := false
var is_flank_left_2 := false
var is_flank_right_1 := false
var is_flank_right_2 := false

func spawn_flank_pos() -> void:

    if not player.has_flank_left_1:
        lerp_component.offset_x = -10
        lerp_component.offset_y = 5
        lerp_component.lerp_amount = 25
        player.has_flank_left_1 = true
        is_flank_left_1 = true

    elif not player.has_flank_right_1:
        lerp_component.offset_x = 10
        lerp_component.offset_y = 5
        lerp_component.lerp_amount = 25
        player.has_flank_right_1 = true
        is_flank_right_1 = true

    elif not player.has_flank_left_2:
        lerp_component.offset_x = -20
        lerp_component.offset_y = 7
        lerp_component.lerp_amount = 15
        player.has_flank_left_2 = true
        is_flank_left_2 = true

    elif not player.has_flank_right_2:
        lerp_component.offset_x = 20
        lerp_component.offset_y = 7
        lerp_component.lerp_amount = 15
        player.has_flank_right_2 = true
        is_flank_right_2 = true
    else:
        queue_free()


func _ready() -> void:
    stats_component.no_health.connect(clear_flank_pos_on_destroy)
    player = get_tree().get_first_node_in_group("player")
    player.fire_rate_timer.timeout.connect(fire_projectiles)
    lerp_component.offset_y = lerp_offset_y
    spawn_flank_pos()
    pickup_audio.play()


func fire_projectiles():
    shoot_audio_player.play_with_variance()
    projectile_spawner.spawn()
    scale_component.tween_scale()


func _process(delta: float) -> void:
    if not is_instance_valid(player):
        queue_free()
        return


func clear_flank_pos_on_destroy() -> void:
    if is_flank_left_1 == true: player.has_flank_left_1 = false
    elif is_flank_left_2 == true: player.has_flank_left_2 = false
    elif is_flank_right_1 == true: player.has_flank_right_1 = false
    elif is_flank_right_2 == true: player.has_flank_right_2 = false
