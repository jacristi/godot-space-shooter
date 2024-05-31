extends Node2D

@export var GreenEnemyScene: PackedScene
@export var YellowEnemyScene: PackedScene
@export var PinkEnemyScene: PackedScene

@export var game_stats: GameStats

var margin := 8
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component: SpawnerComponent = $SpawnerComponent

@onready var green_enemy_spawn_timer: Timer  = $GreenEnemySpawnTimer
@onready var yellow_enemy_spawn_timer: Timer = $YellowEnemySpawnTimer
@onready var pink_enemy_spawn_timer: Timer   = $PinkEnemySpawnTimer


func _ready() -> void:
    green_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            GreenEnemyScene,
            green_enemy_spawn_timer,
            2
        )
    )
    yellow_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            YellowEnemyScene,
            yellow_enemy_spawn_timer,
            10
        )
    )
    pink_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            PinkEnemyScene,
            pink_enemy_spawn_timer,
            20
            )
        )

    game_stats.score_changed.connect(check_enable_enemy_timers)
    
func check_enable_enemy_timers(new_score: int):
    if new_score > 25:
        yellow_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT
    
    if new_score > 80:
        pink_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT


func handle_enemy_spawn(enemy_scene: PackedScene, timer: Timer, time_offset: float=1.0) -> void:
    spawner_component.scene = enemy_scene
    spawner_component.spawn(
        Vector2(
            randf_range(margin, screen_width-margin),
            -16
            )
        )
    var spawn_rate = time_offset / (0.5 + (game_stats.score * 0.01))
    timer.start(spawn_rate + randf_range(0.25, 0.5))
