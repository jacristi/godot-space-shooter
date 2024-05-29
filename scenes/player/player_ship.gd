extends Node2D

@onready var fire_rate_timer: Timer              = $FireRateTimer
@onready var scale_component: ScaleComponent     = $ScaleComponent
@onready var projectile_source_left: Marker2D    = $ProjectileSourceLeft
@onready var projectile_source_right: Marker2D   = $ProjectileSourceRight
@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var move_component: MoveComponent       = $MoveComponent
@onready var ship_animated_sprite: AnimatedSprite2D   = $SpriteAnchor/ShipAnimatedSprite
@onready var thrust_animated_sprite: AnimatedSprite2D = $SpriteAnchor/ThrustAnimatedSprite


func _ready():
    fire_rate_timer.timeout.connect(fire_projectiles)
    pass # Replace with function body.


func _process(delta: float) -> void:
    animate_ship()
    

func fire_projectiles() -> void:
    spawner_component.spawn(projectile_source_left.global_position)
    spawner_component.spawn(projectile_source_right.global_position)
    scale_component.tween_scale()
    
    
func animate_ship() -> void:
    if move_component.velocity.x < 0:
        ship_animated_sprite.play("bank_left")
        thrust_animated_sprite.play("bank_left")
    elif move_component.velocity.x > 0:
        ship_animated_sprite.play("bank_right")
        thrust_animated_sprite.play("bank_right")
    else:
        ship_animated_sprite.play("center")
        thrust_animated_sprite.play("center")
