extends Node2D

@export var game_stats: GameStats
@onready var player_ship: Node2D = $PlayerShip
@onready var score_label: Label = $ScoreLabel

@onready var enemy_generator: Node2D = $EnemyGenerator
@onready var pickup_generator: Node2D = $PickupGenerator

var is_event_in_progress := false

func _ready() -> void:
    update_score_label(game_stats.score)
    game_stats.score_changed.connect(update_score_label)
    player_ship.tree_exiting.connect(player_defeated)
    game_stats.score_changed.connect(handle_score_based_events)
    enemy_generator.boss_event_complete.connect(event_over)


func handle_score_based_events(new_score: int) -> void:
    # when score reaches certain levels, start event
    if new_score > 25:
        enemy_generator.enable_new_enemy("yellow")

    if new_score > 100:
        enemy_generator.enable_new_enemy("pink")

    if new_score > 300:
        enemy_generator.enable_new_enemy("red")

    if new_score > 600:
        enemy_generator.enable_new_enemy("homing")

    if new_score > 1200:
        enemy_generator.enable_new_enemy("tie")

    if new_score > 2000:
        enemy_generator.enable_new_enemy("purple")

    #if new_score > 550 and new_score < 700 and is_event_in_progress == false:
        #is_event_in_progress = true
        #enemy_generator.is_boss_event_in_progress = true
        #enemy_generator.handle_boss_event_start()


func event_over():
    is_event_in_progress = false


func player_defeated() -> void:
    await get_tree().create_timer(2.0).timeout
    get_tree().change_scene_to_file("res://ui/game_over.tscn")


func update_score_label(new_score: int) -> void:
    score_label.text = "Score: %d" % [new_score]
