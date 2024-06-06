# Give the component a class name so it can be instanced as a custom node
class_name PositionClampComponent
extends Node2D

@export var actor: Node2D
@export var margin: = 8

var left_clamp:   float
var right_clamp:  float
var top_clamp:    float
var bottom_clamp: float

var top_border    = 0
var left_border   = 0
var right_border  = ProjectSettings.get_setting("display/window/size/viewport_width")
var bottom_border = ProjectSettings.get_setting("display/window/size/viewport_height")

func _ready() -> void:
    top_clamp    = top_border + margin
    left_clamp   = left_border + margin
    right_clamp  = right_border - margin
    bottom_clamp = bottom_border - margin


func _clamp_entity_position() -> void:
    """ Clamp vertical and horizontal positions based on viewport borders +/- margin """
    actor.global_position.x = clamp(
        actor.global_position.x,
        left_clamp,
        right_clamp
        )
    actor.global_position.y = clamp(
        actor.global_position.y,
        top_clamp,
        bottom_clamp
        )


func _process(delta: float) -> void:
    _clamp_entity_position()
