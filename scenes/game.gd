extends Node2D

@export var game_stats: GameStats
@onready var player_ship: Node2D = $PlayerShip
@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
    update_score_label(game_stats.score)
    game_stats.score_changed.connect(update_score_label)
    player_ship.tree_exiting.connect(player_defeated)

func player_defeated() -> void:
    await get_tree().create_timer(2.0).timeout
    get_tree().change_scene_to_file("res://ui/game_over.tscn")


func update_score_label(new_score: int) -> void:
    score_label.text = "Score: %d" % [new_score]
