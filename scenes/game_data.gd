extends Node

@export var difficulty_factor := 1

const SAVE_PATH = "user://save.cfg"
const DEBUG_SAVE_PATH = "res://save.cfg"

var save_path = SAVE_PATH
var high_score_key := "highscore"

var score_queue := 0

var high_score: int = 0
var score: int = 0 :
    set(value):
        score = value
        Events.score_changed.emit(score)

func set_score(amt:int):
    score += amt

func set_score_queue(amt:int):
    score_queue += amt

var energy: int = 0:
    set(value):
        energy = value
        Events.energy_changed.emit(energy)

func set_energy(amt:int):
    energy += amt


func _ready() -> void:
    Events.adjust_score.connect(set_score_queue)
    Events.adjust_energy.connect(set_energy)

func _process(delta: float) -> void:
    if score_queue != 0:
        score += 1
        score_queue -= 1



func load_high_score() -> void:
    var config = ConfigFile.new()
    var error = config.load(save_path)
    if error != OK: return

    high_score = config.get_value("game", high_score_key)


func save_high_score() -> void:
    var config = ConfigFile.new()
    config.set_value("game", high_score_key, high_score)
    config.save(save_path)
