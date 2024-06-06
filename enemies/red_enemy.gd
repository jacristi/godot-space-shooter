class_name RedEnemy
extends Enemy

var current_shot_count := 0
var current_proj_count := 0
@export var num_projectile_shots := 3
@export var num_projectile_cycles := 3

@export var strafe_velocity: Vector2

@onready var states: Node = $States
@onready var enter_state: TimedStateComponent = %EnterState
@onready var idle_state: TimedStateComponent = %IdleState
@onready var strafe_state: TimedStateComponent = %StrafeState
@onready var pause_state: TimedStateComponent = %PauseState
@onready var fire_state: StateComponent = $States/FireState
@onready var retreat_state: StateComponent = $States/RetreatState

@onready var projectile_timer: Timer = $States/FireState/ProjectileTimer

@onready var move_strafe_component: MoveComponent = %MoveStrafeComponent
@onready var projectile_spawner: SpawnerComponent = %ProjectileSpawner
@onready var fire_audio_stream_player: VariablePitchAudioStreamPlayer = $FireAudioStreamPlayer


func _ready() -> void:
    super()

    for state in states.get_children():
        state = state as StateComponent
        state.disable()

    move_strafe_component.velocity.x = [
        -50, 50
        ].pick_random()

    enter_state.state_finished.connect(idle_state.enable)
    idle_state.state_finished.connect(strafe_state.enable)
    strafe_state.state_finished.connect(pause_state.enable)
    pause_state.state_finished.connect(run_fire_state)
    fire_state.state_finished.connect(idle_state.enable)

    projectile_timer.timeout.connect(run_fire_state)

    enter_state.enable()

func run_fire_state() -> void:
    fire_state.enable()

    if current_shot_count < num_projectile_shots and projectile_timer.time_left <= 0:
        projectile_timer.start()

        fire_projectile()

    elif current_shot_count == num_projectile_shots:
        current_shot_count = 0
        current_proj_count += 1
        fire_state.disable()
        fire_state.state_finished.emit()

        if current_proj_count == num_projectile_cycles:
            fire_state.state_finished.connect(retreat_state.enable)
            idle_state.state_finished.connect(retreat_state.enable)
            pause_state.state_finished.connect(retreat_state.enable)
            strafe_state.state_finished.connect(retreat_state.enable)


func fire_projectile() -> void:
    scale_component.tween_scale()
    fire_audio_stream_player.play()
    projectile_spawner.spawn(global_position)
    current_shot_count += 1

func _process(_delta: float) -> void:
    pass#rint(velocity.x)
