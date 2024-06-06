class_name FollowComponent
extends Node


var player: Node2D
@export var actor: Node2D

func _ready() -> void:
    player = get_tree().get_first_node_in_group("player")


func handle_follow_player() -> void:
    """
        Constantly set this entity's position to player position
        If player is invalid (i.e. destroyed), free this object
    """
    if not is_instance_valid(player):
        queue_free()

    actor.position = player.global_position


func _process(_delta: float) -> void:
    handle_follow_player()
