# Give the component a class name so it can be instanced as a custom node
class_name SpawnerComponent
extends Node2D


@export var scene: PackedScene

func spawn(
        global_spawn_position: Vector2=global_position,
        override_scene_to_spawn: PackedScene=null,
        parent: Node=get_tree().current_scene
    ) -> Node:
    """
        1. Check scene is valid
        2. Create instance of scene
        3. Set instance's parent
        4. Set instance's position

        returns the instance in event calling function in case
        the caller wants to operate on it further
    """

    var scene_to_spawn = scene

    if override_scene_to_spawn != null:
        scene_to_spawn = override_scene_to_spawn

    assert(scene_to_spawn is PackedScene, "Error: Given object to spawn is not a valid PackedScene.")

    # Create instance, set its parent and position
    var instance = scene_to_spawn.instantiate()
    parent.add_child(instance)
    instance.global_position = global_spawn_position

    return instance
