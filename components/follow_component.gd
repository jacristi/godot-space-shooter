class_name FollowComponent
extends Node

var focus: Node2D
@export var actor: Node2D
@export var game_stats: GameStats


func _ready():
    focus = game_stats.player

func _process(delta: float) -> void:
    if is_instance_valid(focus):
        actor.position = focus.global_position
    else:
        queue_free()
