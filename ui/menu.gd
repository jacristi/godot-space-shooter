extends Control



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("fire"):
        get_tree().change_scene_to_file("res://scenes/game.tscn")
