extends ParallaxBackground

@onready var space_layer: ParallaxLayer      = $SpaceLayer
@onready var far_stars_layer: ParallaxLayer  = $FarStarsLayer
@onready var near_stars_layer: ParallaxLayer = $NearStarsLayer


func _process(delta: float) -> void:
    near_stars_layer.motion_offset.y += 16 * delta
    far_stars_layer.motion_offset.y += 7 * delta
    space_layer.motion_offset.y += 3 * delta
