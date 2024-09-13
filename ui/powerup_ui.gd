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

@onready var focus_atk_spd: NinePatchRect = $FocusAtkSpd
@onready var focus_shield: NinePatchRect = $FocusShield
@onready var focus_lightning: NinePatchRect = $FocusLightning
@onready var focus_assist: NinePatchRect = $FocusAssist

@onready var spawner_component: SpawnerComponent = $SpawnerComponent

@onready var atk_spd_up_purchase_timer: Timer = $AtkSpdUpPurchaseTimer
@onready var shield_purchase_timer: Timer = $ShieldPurchaseTimer
@onready var lightning_purchase_timer: Timer = $LightningPurchaseTimer
@onready var flank_ship_purchase_timer: Timer = $FlankShipPurchaseTimer

var player
var pickup_manager

enum focus {atk_spd, shield, lightning, assist}
var current_focus: focus = focus.atk_spd


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
    handle_swtich_focus()
    handle_current_focus()
    handle_purchase_powerups()


func get_focus_for_label(focus_key: focus):
    if focus_key == focus.atk_spd:
        return focus_atk_spd
    if focus_key == focus.shield:
        return focus_shield
    if focus_key == focus.lightning:
        return focus_lightning
    if focus_key == focus.assist:
        return focus_assist
    return null


func handle_current_focus():
    for focus_rect in [focus_atk_spd, focus_shield, focus_lightning, focus_assist]:
        if get_focus_for_label(current_focus) == focus_rect:
            focus_rect.show()
        else:
            focus_rect.hide()


func handle_swtich_focus():
    if Input.is_action_just_pressed("option_1"):
        current_focus = focus.atk_spd
    elif Input.is_action_just_pressed("option_2"):
        current_focus = focus.shield
    elif Input.is_action_just_pressed("option_3"):
        current_focus = focus.lightning
    elif Input.is_action_just_pressed("option_4"):
        current_focus = focus.assist

    if Input.is_action_just_pressed("nav_left"):
        current_focus = clamp(current_focus - 1, 0, len(focus)-1)
    elif Input.is_action_just_pressed("nav_right"):
        current_focus = clamp(current_focus + 1, 0, len(focus)-1)


func handle_purchase_powerups():
    if not Input.is_action_just_pressed("fire"): return

    if current_focus == focus.atk_spd and can_purchase_atk_spd_up():
        purchase_atk_spd_up_powerup()
    elif current_focus == focus.shield and can_purchase_shield():
        purchase_shield_powerup()
    elif current_focus == focus.lightning and can_purchase_lightning():
        purchase_lightning_powerup()
    elif current_focus == focus.assist and can_purchase_flank_ship():
        purchase_flank_ship_powerup()


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


func purchase_lightning_powerup():
    if GameData.energy < powerup_lightning.powerup_cost: return
    GameData.energy -= powerup_lightning.powerup_cost
    handle_pickup_spawn(powerup_lightning.powerup_scene)
    lightning_purchase_timer.start()


func purchase_flank_ship_powerup():
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
