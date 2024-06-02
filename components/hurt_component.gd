# Give the component a class name so it can be instanced as a custom node
class_name HurtComponent
extends Node

# Grab the stats so we can alter the health
@export var stats_component: StatsComponent

# Grab a hurtbox so we know when we have taken a hiet
@export var hurtbox_component: HurtboxComponent

func _ready() -> void:
    # Connect the hurt signal on the hurtbox component to an anonymous function
    # that removes health equal to the damage from the hitbox
    hurtbox_component.hurt.connect(take_damage)

func take_damage(hitbox_component: HitboxComponent) -> void:
    stats_component.health -= hitbox_component.damage
