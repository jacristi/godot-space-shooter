extends Control

const SAVE_PATH = "user://save.cfg"
const DEBUG_SAVE_PATH = "res://save.cfg"

@export var game_stats: GameStats

@onready var score_value_label: Label      = %ScoreValueLabel
@onready var high_score_value_label: Label = %HighScoreValueLabel

var save_path = SAVE_PATH
var high_score_key := "highscore"

func _ready() -> void:
    get_tree().paused = false
    load_high_score()
    if game_stats.score > game_stats.high_score:
        game_stats.high_score = game_stats.score
        save_high_score()

    score_value_label.text = str(game_stats.score)
    high_score_value_label.text = str(game_stats.high_score)


func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("fire"):
        game_stats.score = 0
        get_tree().change_scene_to_file("res://ui/menu.tscn")


func load_high_score() -> void:
    var config = ConfigFile.new()
    var error = config.load(save_path)
    if error != OK: return

    game_stats.high_score = config.get_value("game", high_score_key)


func save_high_score() -> void:
    var config = ConfigFile.new()
    config.set_value("game", high_score_key, game_stats.high_score)
    config.save(save_path)

