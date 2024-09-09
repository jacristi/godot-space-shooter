extends CanvasLayer


@onready var powerup_1: Label = $NinePatchRect/VBoxContainer/HBoxContainer/Powerup1
@onready var powerup_2: Label = $NinePatchRect/VBoxContainer/HBoxContainer/Powerup2
@onready var powerup_3: Label = $NinePatchRect/VBoxContainer/HBoxContainer2/Powerup3
@onready var powerup_4: Label = $NinePatchRect/VBoxContainer/HBoxContainer2/Powerup4

@export var color_active: Color
@export var color_inactive: Color

var pickup_manager
var labels_dict = {
    "powerup_1": powerup_1,
    "powerup_2": powerup_2,
    "powerup_3": powerup_3,
    "powerup_4": powerup_4,
}

func _ready() -> void:
    powerup_1.set("theme_override_colors/font_color", color_inactive)
    powerup_2.set("theme_override_colors/font_color", color_inactive)
    powerup_3.set("theme_override_colors/font_color", color_inactive)
    powerup_4.set("theme_override_colors/font_color", color_inactive)
    pickup_manager = get_tree().get_first_node_in_group("PickupManager")


func _process(_delta: float) -> void:
    if pickup_manager == null:
        pickup_manager = get_tree().get_first_node_in_group("PickupManager")
    check_powerup_status()


func set_label_status(powerup_labelname: String, is_active:bool):
    if not labels_dict.has(powerup_labelname): return
    if is_active:
        labels_dict[powerup_labelname].set("theme_override_colors/font_color", color_active)
    else:
        labels_dict[powerup_labelname].set("theme_override_colors/font_color", color_inactive)


func check_powerup_status():
    if pickup_manager.can_spawn_blue_pickup():
        powerup_1.set("theme_override_colors/font_color", color_active)
    else:
        powerup_1.set("theme_override_colors/font_color", color_inactive)

    if pickup_manager.can_spawn_green_pickup():
        powerup_2.set("theme_override_colors/font_color", color_active)
    else:
        powerup_2.set("theme_override_colors/font_color", color_inactive)

    if pickup_manager.can_spawn_yellow_pickup():
        powerup_3.set("theme_override_colors/font_color", color_active)
    else:
        powerup_3.set("theme_override_colors/font_color", color_inactive)

    if pickup_manager.can_spawn_white_pickup():
        powerup_4.set("theme_override_colors/font_color", color_active)
    else:
        powerup_4.set("theme_override_colors/font_color", color_inactive)
