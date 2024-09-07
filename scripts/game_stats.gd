class_name GameStats

extends Resource

@export var score: int = 0 :
    set(value):
        score = value
        score_changed.emit(score)

@export var high_score: int = 0

@export var energy: int = 0:
    set(value):
        energy = value
        print(energy)
        energy_changed.emit(energy)

@export var difficulty_factor := 1
var player: Node2D

signal score_changed(new_score)
signal energy_changed(new_energy)
