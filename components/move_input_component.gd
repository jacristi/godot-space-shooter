class_name MoveInputComponent
extends Node


@export var move_component: MoveComponent
@export var move_stats: ShipStats

func _input(_event: InputEvent) -> void:
    var input_h_axis = Input.get_axis("move_left", "move_right")
    var input_v_axis = Input.get_axis("move_up", "move_down")

    move_component.velocity = Vector2(
        move_stats.h_move_speed * input_h_axis,
        move_stats.v_move_speed * input_v_axis
        )
