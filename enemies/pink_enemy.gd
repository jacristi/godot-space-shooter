class_name PinkEnemy
extends Enemy


@onready var states: Node = $States
@onready var move_down_state: TimedStateComponent = %MoveDownState
@onready var strafe_state: TimedStateComponent = %StrafeState
@onready var pause_state: TimedStateComponent = %PauseState

@onready var move_strafe_component: MoveComponent = %MoveStrafeComponent

func _ready() -> void:
    super()
    
    for state in states.get_children():
        state = state as StateComponent
        state.disable()
        
    move_strafe_component.velocity.x = [-20, 20].pick_random()
    
    move_down_state.state_finished.connect(strafe_state.enable)
    strafe_state.state_finished.connect(pause_state.enable)
    pause_state.state_finished.connect(move_down_state.enable)
    
    move_down_state.enable()


func _process(delta: float) -> void:
    pass
