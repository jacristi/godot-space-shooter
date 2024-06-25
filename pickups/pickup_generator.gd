extends Node2D

@export var BluePickupScene: PackedScene
@export var YellowPickupScene: PackedScene
@export var GreenPickupScene: PackedScene
@export var WhitePickupScene: PackedScene

var margin := 8
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@export var game_stats: GameStats

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var blue_pickup_spawn_timer: Timer = $BluePickupSpawnTimer
@onready var yelllow_pickup_spawn_timer: Timer = $YelllowPickupSpawnTimer
@onready var green_pickup_spawn_timer: Timer = $GreenPickupSpawnTimer
@onready var white_pickup_spawn_timer: Timer = $WhitePickupSpawnTimer


func _ready() -> void:
    blue_pickup_spawn_timer.timeout.connect(
        handle_pickup_spawn.bind(
            BluePickupScene,
            blue_pickup_spawn_timer
        )
    )

    yelllow_pickup_spawn_timer.timeout.connect(
        handle_pickup_spawn.bind(
            YellowPickupScene,
            yelllow_pickup_spawn_timer
        )
    )

    green_pickup_spawn_timer.timeout.connect(
        handle_pickup_spawn.bind(
            GreenPickupScene,
            green_pickup_spawn_timer
        )
    )

    white_pickup_spawn_timer.timeout.connect(
        handle_pickup_spawn.bind(
            WhitePickupScene,
            white_pickup_spawn_timer
        )
    )

    game_stats.score_changed.connect(check_enable_pickup_timers)


func check_enable_pickup_timers(new_score: int):
    if new_score > 100:
        blue_pickup_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if new_score > 300:
        green_pickup_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if new_score > 500:
        yelllow_pickup_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT

    if new_score > 650:
        white_pickup_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT


func handle_pickup_spawn(pickup_scene: PackedScene, timer: Timer) -> void:
    spawner_component.scene = pickup_scene
    spawner_component.spawn(
        Vector2(
            randf_range(margin, screen_width-margin),
            5
            )
        )
    timer.start()
