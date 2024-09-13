extends Node2D

@onready var player_ship: Node2D = $PlayerShip
@onready var score_label: Label = %ScoreLabel
@onready var energy_label: Label = %EnergyLabel

@onready var enemy_generator: Node2D = $EnemyGenerator


func _ready() -> void:
    update_score_label(GameData.score)
    update_energy_label(GameData.energy)
    Events.score_changed.connect(update_score_label)
    Events.energy_changed.connect(update_energy_label)
    player_ship.tree_exiting.connect(player_defeated)
    Events.score_changed.connect(handle_score_based_events)


func handle_score_based_events(new_score: int) -> void:
    if new_score > 25:
        enemy_generator.enable_new_enemy("yellow")

    if new_score > 100:
        enemy_generator.enable_new_enemy("pink")

    if new_score > 300:
        enemy_generator.enable_new_enemy("red")

    if new_score > 600:
        enemy_generator.enable_new_enemy("homing")

    if new_score > 1500:
        enemy_generator.enable_new_enemy("tie")

    if new_score > 2500:
        enemy_generator.enable_new_enemy("purple")


func player_defeated() -> void:
    await get_tree().create_timer(2.0).timeout
    get_tree().change_scene_to_file("res://ui/game_over.tscn")


func update_score_label(new_score: int) -> void:
    score_label.text = "Score: %d" % [new_score]

func update_energy_label(new_energy: int) -> void:
    energy_label.text = "Energy: %d" % [new_energy]
