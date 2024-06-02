extends Control


func _ready() -> void:
    hide()


func _on_pause_button_pressed():
    if get_tree().paused == true:
        get_tree().paused = false
        hide()
    else:
        get_tree().paused = true
        show()


func _process(delta: float) -> void:
    if Input.is_action_just_pressed("fire"):
        _on_pause_button_pressed()
