extends Control

@export var game_stats: GameStats

@onready var score_value_label: Label      = %ScoreValueLabel
@onready var high_score_value_label: Label = %HighScoreValueLabel


func _ready() -> void:
    if game_stats.score > game_stats.high_score:
        game_stats.high_score = game_stats.score
        
    score_value_label.text = str(game_stats.score)
    high_score_value_label.text = str(game_stats.high_score)


func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept"):
        game_stats.score = 0
        get_tree().change_scene_to_file("res://ui/menu.tscn")

