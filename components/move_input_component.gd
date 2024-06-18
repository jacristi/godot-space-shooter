class_name MoveInputComponent
extends Node


@export var move_component: MoveComponent
@export var move_stats: ShipStats

func _input(_event: InputEvent) -> void:
    var input_h_axis = Input.get_axis("move_left", "move_right")
    var input_v_axis = Input.get_axis("move_up", "move_down")

    var move_direction = Input.get_vector(
        "move_left", "move_right",
        "move_up", "move_down"
    )

    move_component.velocity = move_direction * move_stats.h_move_speed
