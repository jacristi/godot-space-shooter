extends Node2D

@onready var fire_rate_timer: Timer              = $FireRateTimer
@onready var scale_component: ScaleComponent     = $ScaleComponent
@onready var projectile_source_left: Marker2D    = $ProjectileSourceLeft
@onready var projectile_source_right: Marker2D   = $ProjectileSourceRight
@onready var spawner_component: SpawnerComponent = $SpawnerComponent


func _ready():
    fire_rate_timer.timeout.connect(fire_projectiles)
    pass # Replace with function body.


func fire_projectiles() -> void:
    spawner_component.spawn(projectile_source_left.global_position)
    spawner_component.spawn(projectile_source_right.global_position)
    scale_component.tween_scale()
    
