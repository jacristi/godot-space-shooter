extends Node2D

@export var blue_powerup_cost := 3
@export var yellow_powerup_cost := 50
@export var green_powerup_cost := 35
@export var white_powerup_cost := 75

@export var BluePickupScene: PackedScene
@export var YellowPickupScene: PackedScene
@export var GreenPickupScene: PackedScene
@export var WhitePickupScene: PackedScene

@onready var blue_pickup_spawn_timer: Timer = $BluePickupSpawnTimer
@onready var yellow_pickup_spawn_timer: Timer = $YellowPickupSpawnTimer
@onready var green_pickup_spawn_timer: Timer = $GreenPickupSpawnTimer
@onready var white_pickup_spawn_timer: Timer = $WhitePickupSpawnTimer


var margin := 8
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
var player


func _ready() -> void:
    if player == null:
        player = get_tree().get_first_node_in_group("player")

func handle_pickup_spawn(pickup_scene: PackedScene) -> void:
    if not is_instance_valid(player): return
    spawner_component.scene = pickup_scene
    spawner_component.spawn(
        Vector2(player.position.x, player.position.y-15)
        )

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("option_1") and can_spawn_blue_pickup():
        purchase_blue_powerup()

    if Input.is_action_just_pressed("option_2") and can_spawn_green_pickup():
        purchase_green_powerup()

    if Input.is_action_just_pressed("option_3") and can_spawn_yellow_pickup():
        purchase_yellow_powerup()

    if Input.is_action_just_pressed("option_4") and can_spawn_white_pickup():
        purchase_white_powerup()


func purchase_blue_powerup():
    if GameData.energy < blue_powerup_cost: return
    GameData.energy -= blue_powerup_cost
    handle_pickup_spawn(BluePickupScene)
    blue_pickup_spawn_timer.start()


func purchase_yellow_powerup():
    if GameData.energy < yellow_powerup_cost: return
    GameData.energy -= yellow_powerup_cost
    handle_pickup_spawn(YellowPickupScene)
    yellow_pickup_spawn_timer.start()


func purchase_green_powerup():
    if GameData.energy < green_powerup_cost: return
    GameData.energy -= green_powerup_cost
    handle_pickup_spawn(GreenPickupScene)
    green_pickup_spawn_timer.start()


func purchase_white_powerup():
    if GameData.energy < white_powerup_cost: return
    GameData.energy -= white_powerup_cost
    handle_pickup_spawn(WhitePickupScene)
    white_pickup_spawn_timer.start()


func can_player_get_flank_ship():
    if not is_instance_valid(player): return false
    return not player.has_flank_left_1 \
        or not player.has_flank_left_2 \
        or not player.has_flank_right_1 \
        or not player.has_flank_right_2

func can_spawn_blue_pickup() -> bool: return blue_pickup_spawn_timer.time_left <= 0 and GameData.energy >= 10
func can_spawn_green_pickup() -> bool: return green_pickup_spawn_timer.time_left <= 0 and GameData.energy >= 20
func can_spawn_yellow_pickup() -> bool: return yellow_pickup_spawn_timer.time_left <= 0 and GameData.energy >= 25
func can_spawn_white_pickup() -> bool: return white_pickup_spawn_timer.time_left <= 0 \
    and GameData.energy >= 35 \
    and can_player_get_flank_ship()
