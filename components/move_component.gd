class_name MoveComponent
extends Node


@export var velocity: Vector2
@export var actor: Node2D

func _process(delta: float) -> void:
    actor.translate(delta * velocity)
