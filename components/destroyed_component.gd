class_name DestroyedComponent
extends Node

@export var actor: Node2D
@export var stats_component: StatsComponent
@export var spawner_component: SpawnerComponent

func _ready() -> void:
    stats_component.no_health.connect(destroy)


func destroy() -> void:
    """
        1. Check if spawner component exists, call spawn_scene if so
        2. Frees entity object
    """
    if spawner_component != null:
        spawner_component.spawn(actor.global_position)

    actor.queue_free()
