class_name LerpComponent
extends Node

@export var lerp_amount := 1.0
@export var actor: Node2D
@export var target: Node2D

@export var lerp_x := true
@export var lerp_y := false

@export var offset_x := 0.0
@export var offset_y := 0.0

func _ready() -> void:
    if target == null:
        target = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
    if not is_instance_valid(target):
        return

    if lerp_x:
        actor.global_position.x = lerp(
            actor.global_position.x,
            target.global_position.x + offset_x,
            delta*lerp_amount
            )
    if lerp_y:
        actor.global_position.y = lerp(
            actor.global_position.y,
            target.global_position.y + offset_y,
            delta*lerp_amount
            )
