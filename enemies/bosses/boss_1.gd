class_name Boss1
extends Enemy


@onready var states: Node = $States
@onready var spawn_state: TimedStateComponent = %SpawnState
@onready var strafe_shoot_state: TimedStateComponent = %StrafeShootState
@onready var shield_spawn_state: StateComponent = $States/ShieldSpawnState
@onready var idle_shoot_state: TimedStateComponent = %IdleShootState

@onready var shield_spawner_component: SpawnerComponent = $ShieldSpawnerComponent

func _ready() -> void:
    super()
    for state in states.get_children():
        state = state as StateComponent
        state.disable()

    spawn_state.state_finished.connect(strafe_shoot_state.enable)
    strafe_shoot_state.state_finished.connect(shield_spawn_state.enable)
    shield_spawn_state.state_finished.connect(idle_shoot_state.enable)
    idle_shoot_state.state_finished.connect(strafe_shoot_state.enable)

    spawn_state.enable()
