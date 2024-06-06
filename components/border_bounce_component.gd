# Give the component a class name so it can be instanced as a custom node
class_name BorderBounceComponent
extends Node

@export var margin: = 8
@export var actor: Node2D
@export var move_component: MoveComponent


@export var should_bounce_off_left: bool   = true
@export var should_bounce_off_right: bool  = true
@export var should_bounce_off_top: bool    = false
@export var should_bounce_off_bottom: bool = false

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


func handle_border_breach() -> void:
    if actor.global_position.x < left_clamp and should_bounce_off_left:
        actor.global_position.x = left_clamp
        move_component.velocity = move_component.velocity.bounce(Vector2.RIGHT)

    if actor.global_position.x > right_clamp and should_bounce_off_right:
        actor.global_position.x = right_clamp
        move_component.velocity = move_component.velocity.bounce(Vector2.LEFT)

    if actor.global_position.y < top_clamp and should_bounce_off_top:
        actor.global_position.y = top_clamp
        move_component.velocity = move_component.velocity.bounce(Vector2.DOWN)

    if actor.global_position.y > bottom_clamp and should_bounce_off_bottom:
        actor.global_position.y = bottom_clamp
        move_component.velocity = move_component.velocity.bounce(Vector2.DOWN)


func _process(delta: float) -> void:
    handle_border_breach()
