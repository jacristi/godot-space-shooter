class_name TieEnemy
extends Enemy

@onready var states: Node = $States
@onready var spawn_state: TimedStateComponent = %SpawnState
@onready var move_down_lerp: TimedStateComponent = %MoveDownLerp
@onready var move_up_component: TimedStateComponent = %MoveUpComponent
@onready var projectile_spawner: SpawnerComponent = $ProjectileSpawner
@onready var cooldown_timer: Timer = $ProjectileSpawner/Timer

var can_shoot := false

func _ready() -> void:
    super()

    for state in states.get_children():
        state = state as StateComponent
        state.disable()

    spawn_state.state_finished.connect(move_down_lerp.enable)
    move_down_lerp.state_finished.connect(transition_move_down_lerp_state)
    move_up_component.state_finished.connect(transition_move_up_lerp_state)

    spawn_state.enable()

    cooldown_timer.timeout.connect(fire_projectile)
    print(cooldown_timer.wait_time)


func transition_move_down_lerp_state():
    move_up_component.enable()
    can_shoot = true


func transition_move_up_lerp_state():
    move_down_lerp.enable()
    can_shoot = false


func fire_projectile() -> void:
    if not can_shoot:
        return

    projectile_spawner.spawn()
    scale_component.tween_scale()
