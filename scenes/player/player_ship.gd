extends Node2D

@export var self_node: Node2D
@export var game_stats: GameStats

@onready var fire_rate_timer: Timer              = $FireRateTimer
@onready var scale_component: ScaleComponent     = $ScaleComponent
@onready var projectile_source_left: Marker2D    = $ProjectileSourceLeft
@onready var projectile_source_right: Marker2D   = $ProjectileSourceRight
@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var move_component: MoveComponent       = $MoveComponent
@onready var ship_animated_sprite: AnimatedSprite2D   = $SpriteAnchor/ShipAnimatedSprite
@onready var thrust_animated_sprite: AnimatedSprite2D = $SpriteAnchor/ThrustAnimatedSprite
@onready var shoot_audio_player: VariablePitchAudioStreamPlayer = $ShootAudioStreamPlayer
@onready var level_up_audio_stream_player: VariablePitchAudioStreamPlayer = $LevelUpAudioStreamPlayer

var has_flank_left_1 := false
var has_flank_left_2 := false
var has_flank_right_1 := false
var has_flank_right_2 := false

var TIMER_POINT_BREAKS = {
        100: .375,
        200: .35,
        300: .325,
        500: .3,
        700: .275,
        900: .25,
        1200: .225,
        1500: .2,
        1800: .175,
        2300: .15,
        3000: .125,
        4000: .1,
    }

func incr_fire_rate():
    if fire_rate_timer.wait_time <= .1: return
    fire_rate_timer.wait_time = fire_rate_timer.wait_time - .025


func _ready():
    fire_rate_timer.timeout.connect(fire_projectiles)
    game_stats.player = self_node


func _process(_delta: float) -> void:
    animate_ship()


func fire_projectiles() -> void:
    shoot_audio_player.play_with_variance()
    spawner_component.spawn(projectile_source_left.global_position)
    spawner_component.spawn(projectile_source_right.global_position)
    scale_component.tween_scale()


func animate_ship() -> void:
    if move_component.velocity.x < 0:
        ship_animated_sprite.play("bank_left")
        thrust_animated_sprite.play("bank_left")
    elif move_component.velocity.x > 0:
        ship_animated_sprite.play("bank_right")
        thrust_animated_sprite.play("bank_right")
    else:
        ship_animated_sprite.play("center")
        thrust_animated_sprite.play("center")
