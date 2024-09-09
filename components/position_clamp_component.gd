# Give the component a class name so it can be instanced as a custom node
class_name PositionClampComponent
extends Node2D

@export var actor: Node2D
@export var left_margin: = 8
@export var right_margin: = 8
@export var top_margin: = 16
@export var bottom_margin: = 24

@export var should_clamp_left   := true
@export var should_clamp_right  := true
@export var should_clamp_top    := true
@export var should_clamp_bottom := true

var left_clamp:   float
var right_clamp:  float
var top_clamp:    float
var bottom_clamp: float

var bottom_border = ProjectSettings.get_setting("display/window/size/viewport_height")
var left_border   = 0
var right_border  = ProjectSettings.get_setting("display/window/size/viewport_width")
var top_border    = 0

func _ready() -> void:
    bottom_clamp    = bottom_border - bottom_margin
    left_clamp   = left_border + left_margin
    right_clamp  = right_border - right_margin
    top_clamp = top_border + top_margin


func _clamp_entity_position() -> void:
    """ Clamp vertical and horizontal positions based on viewport borders +/- margin """
    if should_clamp_left and actor.global_position.x < left_clamp:
        actor.global_position.x = left_clamp

    if should_clamp_right and actor.global_position.x > right_clamp:
        actor.global_position.x = right_clamp

    if should_clamp_top and actor.global_position.y > bottom_clamp:
        actor.global_position.y = bottom_clamp

    if should_clamp_bottom and actor.global_position.y < top_clamp:
        actor.global_position.y = top_clamp

        #actor.global_position.x = clamp(
            #actor.global_position.x,
            #left_clamp,
            #right_clamp
            #)
    #if clamp_vertical:
        #actor.global_position.y = clamp(
            #actor.global_position.y,
            #top_clamp,
            #bottom_clamp
            #)


func _process(_delta: float) -> void:
    _clamp_entity_position()
