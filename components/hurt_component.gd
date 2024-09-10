class_name HurtComponent
extends Node


@export var stats_component: StatsComponent
@export var hurtbox_component: HurtboxComponent


func _ready() -> void:
    hurtbox_component.hurt.connect(take_damage)


func take_damage(hitbox_component: HitboxComponent) -> void:
    stats_component.health -= hitbox_component.damage
