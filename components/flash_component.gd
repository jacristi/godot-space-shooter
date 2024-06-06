class_name FlashComponent
extends Node


var timer: Timer = Timer.new()
var original_sprite_material: Material

@export var flash_material: Material
@export var sprite: CanvasItem
@export var flash_duration: = 0.2

func _ready() -> void:
    add_child(timer)
    original_sprite_material = sprite.material

func flash(override_flash_material=null) -> void:
    """
        1. Set sprite material to flash material
        2. Wait for timer to complete
        3. Reset sprite material to original
    """
    var material_to_use = flash_material

    if override_flash_material != null:
        print('use override material')
        material_to_use = override_flash_material

    sprite.material = material_to_use

    timer.start(flash_duration)
    await timer.timeout

    sprite.material = original_sprite_material
