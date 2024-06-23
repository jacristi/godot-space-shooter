class_name PurpleEnemy
extends Enemy

@onready var states: Node = $States
@onready var spawn_state: TimedStateComponent = $States/SpawnState
@onready var lerp_to_player_y_state: TimedStateComponent = $States/LerpToPlayerYState
@onready var retreat_state: StateComponent = $States/RetreatState

@onready var left_projectile_spawner: SpawnerComponent = $LeftProjectileSpawner
@onready var right_projectile_spawner: SpawnerComponent = $RightProjectileSpawner
@onready var fire_rate_timer: Timer = $FireRateTimer

var can_fire := false

func _ready() -> void:
    super()

    fire_rate_timer.timeout.connect(fire_projectiles)

    for state in states.get_children():
        state = state as StateComponent
        state.disable()

        spawn_state.enable()

        spawn_state.state_finished.connect(start_lerp_to_player_y_state)
        lerp_to_player_y_state.state_finished.connect(end_lerp_to_player_y_state)


func fire_projectiles() -> void:
    if not can_fire:
        return

    left_projectile_spawner.spawn()
    right_projectile_spawner.spawn()


func start_lerp_to_player_y_state():
    lerp_to_player_y_state.enable()
    can_fire = true


func end_lerp_to_player_y_state():
    retreat_state.enable()
    can_fire = false
