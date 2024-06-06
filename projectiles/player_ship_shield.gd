extends Node2D

@onready var duration_timer: Timer = $DurationTimer
@onready var flash_component: FlashComponent = $FlashComponent
@onready var flash_timer: Timer = $FlashTimer


var is_flashing := false

func _ready():
    print("ASDASFASDFASF")
    duration_timer.timeout.connect(
        dissipate_shield
    )


func _process(_delta: float) -> void:
    if duration_timer.time_left <= 3.25:
        set_flash_continuous()


func dissipate_shield():
    print("TIME UP END SHIELD")
    queue_free()


func set_flash_continuous() -> void:
    if is_flashing == true:
        return
    is_flashing = true
    flash_timer.process_mode = Node.PROCESS_MODE_INHERIT
    flash_timer.timeout.connect(warn_end_of_life)
    flash_timer.start()


func warn_end_of_life() -> void:
    print("Play sound here....")
    flash_component.flash()
