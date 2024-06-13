class_name MoveComponent
extends Node


@export var velocity: Vector2
@export var actor: Node2D
@export var has_random_x_direction := true


func _ready() -> void:
    if has_random_x_direction:
        velocity = Vector2(
            [-velocity.x, velocity.x].pick_random(),
            velocity.y
            )


func _process(delta: float) -> void:
    actor.translate(delta * velocity)
