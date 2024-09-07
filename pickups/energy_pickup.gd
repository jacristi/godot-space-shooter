extends Node2D

@export var game_stats: GameStats

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var states: Node = $States
@onready var spawn_state: TimedStateComponent = $States/SpawnState
@onready var move_to_collect_state: StateComponent = $States/MoveToCollectState
@onready var spawn_move_component: MoveComponent = $States/SpawnState/MoveComponent


func _ready() -> void:
    randomize()
    hitbox_component.hit_hurtbox.connect(handle_on_collect)
    for state in states.get_children():
        state = state as StateComponent
        state.disable()

    spawn_move_component.velocity.x = randf_range(-150, 150)
    spawn_move_component.velocity.y = randf_range(-150, 50)
    spawn_state.state_finished.connect(move_to_collect_state.enable)
    spawn_state.enable()

func handle_on_collect(_hurtbox: HurtboxComponent):
    game_stats.energy += 1
    queue_free()
