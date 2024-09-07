class_name MoveToComponent
extends Node


@export var speed := 1.0
@export var actor: Node2D
@export var target: Node2D


func _ready() -> void:
    if target == null:
        target = get_tree().get_first_node_in_group("player")



func _process(delta: float) -> void:
    if not is_instance_valid(target):
        return

    actor.global_position = actor.global_position.move_toward(
        target.global_position,
        delta*speed
        )
