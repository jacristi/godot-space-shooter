# Give the component a class name so it can be instanced as a custom node
class_name DestroyedComponent
extends Node

# Export the actor this component will operate on
@export var actor: Node2D
@export var stats_component: StatsComponent
@export var spawner_component: SpawnerComponent

func _ready() -> void:
    # connect no health signal to destroy function
    stats_component.no_health.connect(destroy)


func destroy() -> void:
    """
        1. Check if spawner component exists, call spawn_scene if so
        2. Frees entity object
    """
    if spawner_component != null:
        spawner_component.spawn(actor.global_position)

    actor.queue_free()
