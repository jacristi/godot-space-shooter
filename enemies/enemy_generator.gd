extends Node2D

@export var GreenEnemyScene: PackedScene
@export var YellowEnemyScene: PackedScene
@export var PinkEnemyScene: PackedScene
@export var RedEnemyScene: PackedScene

@export var BossScenes: Array[PackedScene]
var current_boss_index := 0

@export var game_stats: GameStats

var margin := 8
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component: SpawnerComponent = $SpawnerComponent

@onready var green_enemy_spawn_timer: Timer  = $GreenEnemySpawnTimer
@onready var yellow_enemy_spawn_timer: Timer = $YellowEnemySpawnTimer
@onready var pink_enemy_spawn_timer: Timer   = $PinkEnemySpawnTimer
@onready var red_enemy_spawn_timer: Timer = $RedEnemySpawnTimer

@onready var event_start_timer: Timer = $EventStartTimer
@onready var event_end_timer: Timer = $EventEndTimer

var is_event_in_progress = false

func _ready() -> void:
    event_start_timer.timeout.connect(handle_event)
    event_end_timer.timeout.connect(handle_event_complete)
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
            50
            )
        )

    red_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            RedEnemyScene,
            red_enemy_spawn_timer,
            120
            )
        )

    game_stats.score_changed.connect(check_enable_enemy_timers)

func check_enable_enemy_timers(new_score: int):
    if new_score > 25:
        yellow_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if new_score > 80:
        pink_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if new_score > 50:
        red_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if new_score >= 1000 and new_score < 2000 and current_boss_index == 0 and not is_event_in_progress:
        handle_event_start()


func handle_enemy_spawn(
        enemy_scene: PackedScene,
        timer: Timer,
        time_offset: float=1.0
    ) -> void:

    if not is_event_in_progress:
        spawner_component.scene = enemy_scene
        spawner_component.spawn(
            Vector2(
                randf_range(margin, screen_width-margin),
                -16
                )
            )
    var spawn_rate = time_offset / (0.5 + (game_stats.score * 0.01))
    timer.start(spawn_rate + randf_range(0.25, 0.5))


func handle_event_end() -> void:
    event_end_timer.start()


func handle_event_complete() -> void:
    is_event_in_progress = false


func handle_event_start() -> void:
    is_event_in_progress = true
    event_start_timer.start()


func handle_event() -> void:
    spawner_component.scene = BossScenes[current_boss_index]
    current_boss_index += 1
    var boss_instance = spawner_component.spawn(
        Vector2(
            randf_range(margin, screen_width-margin),
            -16
            )
        )
    boss_instance.stats_component.no_health.connect(handle_event_end)

