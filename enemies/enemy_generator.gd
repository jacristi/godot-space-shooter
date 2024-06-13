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

@onready var boss_event_start_timer: Timer = $BossEventStartTimer
@onready var boss_event_end_timer: Timer = $BossEventEndTimer

var is_boss_event_in_progress = false

var enemy_types_enabled = {
    'green':  false,
    'yellow': false,
    'pink':   false,
    'red':    false,
}

signal boss_event_complete()


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


func enable_new_enemy(enemy_type: String) -> void:
    if not enemy_types_enabled.has(enemy_type):
        print('invalid enemy: ' + enemy_type)
        return

    if enemy_types_enabled[enemy_type] == true:
        return

    print("ENABLING ENEMY: " + enemy_type)

    if enemy_type == 'yellow':
        yellow_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if enemy_type == 'pink':
        pink_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if enemy_type == 'red':
        red_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    enemy_types_enabled[enemy_type] = true


func handle_enemy_spawn(
        enemy_scene: PackedScene,
        timer: Timer,
        time_offset: float=1.0
    ) -> void:

    if not is_boss_event_in_progress:
        spawner_component.scene = enemy_scene
        spawner_component.spawn(
            Vector2(
                randf_range(margin, screen_width-margin),
                -16
                )
            )
    var spawn_rate = time_offset / (0.5 + (game_stats.score * 0.01))
    timer.start(spawn_rate + randf_range(0.25, 0.5))


func handle_boss_event_end() -> void:
    boss_event_end_timer.start()
    await boss_event_end_timer.timeout
    boss_event_complete.emit()
    is_boss_event_in_progress = false


func handle_boss_event_start() -> void:
    boss_event_start_timer.start()
    await boss_event_start_timer.timeout
    handle_boss_event()


func handle_boss_event() -> void:
    spawner_component.scene = BossScenes[current_boss_index]
    current_boss_index += 1
    var boss_instance = spawner_component.spawn(
        Vector2(
            randf_range(margin, screen_width-margin),
            -16
            )
        )
    boss_instance.stats_component.no_health.connect(handle_boss_event_end)

