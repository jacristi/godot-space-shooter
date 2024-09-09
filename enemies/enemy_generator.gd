extends Node2D

@export var GreenEnemyScene: PackedScene
@export var YellowEnemyScene: PackedScene
@export var PinkEnemyScene: PackedScene
@export var RedEnemyScene: PackedScene
@export var HomingEnemyScene: PackedScene
@export var TieEnemyScene: PackedScene
@export var PurpleEnemyScene: PackedScene

@export var BossScenes: Array[PackedScene]
var current_boss_index := 0

var margin := 8
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component: SpawnerComponent = $SpawnerComponent

@onready var green_enemy_spawn_timer: Timer  = $GreenEnemySpawnTimer
@onready var yellow_enemy_spawn_timer: Timer = $YellowEnemySpawnTimer
@onready var pink_enemy_spawn_timer: Timer   = $PinkEnemySpawnTimer
@onready var red_enemy_spawn_timer: Timer = $RedEnemySpawnTimer
@onready var homing_enemy_spawn_timer: Timer = $HomingEnemySpawnTimer
@onready var tie_enemy_spawn_timer: Timer = $TieEnemySpawnTimer
@onready var purple_enemy_spawn_timer: Timer = $PurpleEnemySpawnTimer


var enemy_types_enabled = {
    'green':  false,
    'yellow': false,
    'pink':   false,
    'red':    false,
    'homing': false,
    'tie':    false,
    'purple': false,
}


func _ready() -> void:
    green_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            GreenEnemyScene,
            green_enemy_spawn_timer
        )
    )
    yellow_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            YellowEnemyScene,
            yellow_enemy_spawn_timer
        )
    )
    pink_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            PinkEnemyScene,
            pink_enemy_spawn_timer
            )
        )
    red_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            RedEnemyScene,
            red_enemy_spawn_timer
            )
        )
    homing_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            HomingEnemyScene,
            homing_enemy_spawn_timer
            )
        )
    tie_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            TieEnemyScene,
            tie_enemy_spawn_timer
            )
        )
    purple_enemy_spawn_timer.timeout.connect(
        handle_enemy_spawn.bind(
            PurpleEnemyScene,
            purple_enemy_spawn_timer
            )
        )


func enable_new_enemy(enemy_type: String) -> void:
    if not enemy_types_enabled.has(enemy_type):
        print('invalid enemy: ' + enemy_type)
        return

    if enemy_types_enabled[enemy_type] == true:
        return

    if enemy_type == 'yellow':
        yellow_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if enemy_type == 'pink':
        pink_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if enemy_type == 'red':
        red_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if enemy_type == 'homing':
        homing_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if enemy_type == 'tie':
        tie_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if enemy_type == 'purple':
        purple_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    enemy_types_enabled[enemy_type] = true


func handle_enemy_spawn(
        enemy_scene: PackedScene,
        timer: Timer,
        time_offset: float=1.0
    ) -> void:

    spawner_component.scene = enemy_scene
    var ins = spawner_component.spawn(
        Vector2(
            randf_range(margin, screen_width-margin),
            -16
            )
        )
    var spawn_rate = clamp(ins.spawn_time/(.05 + GameData.score * .005), 1, ins.spawn_time)
    timer.start(spawn_rate + randf_range(0.25, 0.5))
