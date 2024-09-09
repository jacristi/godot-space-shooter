extends Control

@onready var score_value_label: Label      = %ScoreValueLabel
@onready var high_score_value_label: Label = %HighScoreValueLabel


func _ready() -> void:
    get_tree().paused = false
    #load_high_score()
    if GameData.score > GameData.high_score:
        GameData.high_score = GameData.score


    score_value_label.text = str(GameData.score)
    high_score_value_label.text = str(GameData.high_score)


func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("fire"):
        GameData.score = 0
        get_tree().change_scene_to_file("res://ui/menu.tscn")
