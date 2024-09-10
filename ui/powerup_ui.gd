extends CanvasLayer


@export var powerup_atk_spd: Resource
@export var powerup_shield: Resource
@export var powerup_lightning: Resource
@export var powerup_flank_ship: Resource

@export var color_inactive: Color

@onready var label_atk_speed: Label = $NinePatchRect/VBoxContainer/HBoxContainer/PowerupAtkSpeed
@onready var label_shield: Label = $NinePatchRect/VBoxContainer/HBoxContainer/PowerupShield
@onready var label_lightning: Label = $NinePatchRect/VBoxContainer/HBoxContainer2/PowerupLightning
@onready var label_flank_ship: Label = $NinePatchRect/VBoxContainer/HBoxContainer2/PowerupFlankShip

@onready var spawner_component: SpawnerComponent = $SpawnerComponent

@onready var atk_spd_up_purchase_timer: Timer = $AtkSpdUpPurchaseTimer
@onready var shield_purchase_timer: Timer = $ShieldPurchaseTimer
@onready var lightning_purchase_timer: Timer = $LightningPurchaseTimer
@onready var flank_ship_purchase_timer: Timer = $FlankShipPurchaseTimer

var player
var pickup_manager


func _ready() -> void:
    label_atk_speed.text = '1: ATK SPD UP (%d)' % [powerup_atk_spd.powerup_cost]
    label_shield.text = '2: SHIELD (%d)' % [powerup_shield.powerup_cost]
    label_lightning.text = '3: LIGHTNING (%d)' % [powerup_lightning.powerup_cost]
    label_flank_ship.text = '4: ASSIST (%d)' % [powerup_flank_ship.powerup_cost]

    label_atk_speed.set("theme_override_colors/font_color", color_inactive)
    label_shield.set("theme_override_colors/font_color", color_inactive)
    label_lightning.set("theme_override_colors/font_color", color_inactive)
    label_flank_ship.set("theme_override_colors/font_color", color_inactive)

    # labels_dict[powerup_labelname].set("theme_override_colors/font_color", color_active)
    pickup_manager = get_tree().get_first_node_in_group("PickupManager")
    player = get_tree().get_first_node_in_group("player")


func _process(_delta: float) -> void:
    if pickup_manager == null:
        pickup_manager = get_tree().get_first_node_in_group("PickupManager")

    if player == null:
        player = get_tree().get_first_node_in_group("player")

    check_powerup_status()

    if Input.is_action_just_pressed("option_1") and can_purchase_atk_spd_up():
        purchase_atk_spd_up_powerup()

    if Input.is_action_just_pressed("option_2") and can_purchase_shield():
        purchase_shield_powerup()

    if Input.is_action_just_pressed("option_3") and can_purchase_lightning():
        purchase_yellow_powerup()

    if Input.is_action_just_pressed("option_4") and can_purchase_flank_ship():
        purchase_white_powerup()


func purchase_atk_spd_up_powerup():
    if GameData.energy < powerup_atk_spd.powerup_cost: return
    GameData.energy -= powerup_atk_spd.powerup_cost
    handle_pickup_spawn(powerup_atk_spd.powerup_scene)
    atk_spd_up_purchase_timer.start()


func purchase_shield_powerup():
    if GameData.energy < powerup_shield.powerup_cost: return
    GameData.energy -=  powerup_shield.powerup_cost
    handle_pickup_spawn( powerup_shield.powerup_scene)
    shield_purchase_timer.start()


func purchase_yellow_powerup():
    if GameData.energy < powerup_lightning.powerup_cost: return
    GameData.energy -= powerup_lightning.powerup_cost
    handle_pickup_spawn(powerup_lightning.powerup_scene)
    lightning_purchase_timer.start()


func purchase_white_powerup():
    if GameData.energy < powerup_flank_ship.powerup_cost: return
    GameData.energy -= powerup_flank_ship.powerup_cost
    handle_pickup_spawn(powerup_flank_ship.powerup_scene)
    flank_ship_purchase_timer.start()


func can_player_get_atk_spd_up():
    if not is_instance_valid(player): return false
    return player.can_incr_fire_rate()


func can_player_get_flank_ship():
    if not is_instance_valid(player): return false
    return not player.has_flank_left_1 \
        or not player.has_flank_left_2 \
        or not player.has_flank_right_1 \
        or not player.has_flank_right_2


func handle_pickup_spawn(pickup_scene: PackedScene) -> void:
    if not is_instance_valid(player): return
    spawner_component.scene = pickup_scene
    spawner_component.spawn(
        Vector2(player.position.x, player.position.y-15)
        )


func can_purchase_atk_spd_up() -> bool: return atk_spd_up_purchase_timer.time_left <= 0 \
    and GameData.energy >= powerup_atk_spd.powerup_cost \
    and can_player_get_atk_spd_up() \
    and is_instance_valid(player)


func can_purchase_shield() -> bool: return shield_purchase_timer.time_left <= 0 \
    and GameData.energy >= powerup_shield.powerup_cost \
    and is_instance_valid(player)


func can_purchase_lightning() -> bool: return lightning_purchase_timer.time_left <= 0 \
    and GameData.energy >= powerup_lightning.powerup_cost \
    and is_instance_valid(player)


func can_purchase_flank_ship() -> bool: return flank_ship_purchase_timer.time_left <= 0 \
    and GameData.energy >= powerup_flank_ship.powerup_cost \
    and can_player_get_flank_ship() \
    and is_instance_valid(player)


func check_powerup_status():
    if can_purchase_atk_spd_up():
        label_atk_speed.set("theme_override_colors/font_color", powerup_atk_spd.powerup_color)
    else:
        label_atk_speed.set("theme_override_colors/font_color", color_inactive)

    if can_purchase_shield():
        label_shield.set("theme_override_colors/font_color", powerup_shield.powerup_color)
    else:
        label_shield.set("theme_override_colors/font_color", color_inactive)

    if can_purchase_lightning():
        label_lightning.set("theme_override_colors/font_color", powerup_lightning.powerup_color)
    else:
        label_lightning.set("theme_override_colors/font_color", color_inactive)
#
    if can_purchase_flank_ship():
        label_flank_ship.set("theme_override_colors/font_color", powerup_flank_ship.powerup_color)
    else:
        label_flank_ship.set("theme_override_colors/font_color", color_inactive)
