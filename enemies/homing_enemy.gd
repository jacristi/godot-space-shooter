class_name HomingEnemy
extends Enemy

@onready var states: Node = $States
@onready var spawn_state: TimedStateComponent = $States/SpawnState
@onready var line_up_state: StateComponent = $States/LineUpState
@onready var fly_down_state: StateComponent = $States/FlyDownState


func _ready() -> void:
    super()
    for state in states.get_children():
        state = state as StateComponent
        state.disable()

    spawn_state.state_finished.connect(line_up_state.enable)
    line_up_state.state_finished.connect(fly_down_state.enable)

    spawn_state.enable()

