extends Node2D


@onready var player_ship: Node2D = $PlayerShip

func _ready() -> void:
    player_ship.tree_exiting.connect(player_defeated)

func player_defeated() -> void:
    await get_tree().create_timer(2.0).timeout
    get_tree().change_scene_to_file("res://ui/game_over.tscn")
