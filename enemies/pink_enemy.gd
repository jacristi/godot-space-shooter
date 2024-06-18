class_name PinkEnemy
extends Enemy


@onready var states: Node = $States
@onready var move_down_state: TimedStateComponent = %MoveDownState
@onready var strafe_state: TimedStateComponent = %StrafeState
@onready var fire_state: StateComponent = $States/FireState
@onready var pause_state: TimedStateComponent = %PauseState

@onready var move_strafe_component: MoveComponent = %MoveStrafeComponent
@onready var projectile_spawner: SpawnerComponent = %ProjectileSpawner
@onready var fire_audio_stream_player: VariablePitchAudioStreamPlayer = $FireAudioStreamPlayer

func _ready() -> void:
    super()

    for state in states.get_children():
        state = state as StateComponent
        state.disable()

    move_down_state.state_finished.connect(strafe_state.enable)
    strafe_state.state_finished.connect(pause_state.enable)
    pause_state.state_finished.connect(run_fire_state)
    fire_state.state_finished.connect(move_down_state.enable)

    move_down_state.enable()


func run_fire_state() -> void:
    fire_state.enable()
    fire_projectile()
    fire_state.disable()
    fire_state.state_finished.emit()

func fire_projectile() -> void:
    scale_component.tween_scale()
    projectile_spawner.spawn(global_position)
    fire_audio_stream_player.play()
