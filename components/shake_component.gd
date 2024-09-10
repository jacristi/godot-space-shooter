class_name ShakeComponent
extends Node

@export var node: Node2D
@export var shake_amount: = 2.0
@export var shake_duration: = 0.4

var shake = 0


func tween_shake():
    # Set the shake to the shake amount (shake is the value used in the process function to
    # shake the node)
    shake = shake_amount

    # Create a tween
    var tween = create_tween()

    # Tween the shake value from current down to 0 over the shake duration
    tween.tween_property(self, "shake", 0.0, shake_duration).from_current()

func _physics_process(_delta: float) -> void:
    # Manipulate the position of the node by the shake amount every physics frame
    # Use randf_range to pick a random x and y value using the shake value
    node.position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
