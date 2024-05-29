extends Node2D

@onready var move_component:  MoveComponent  = $MoveComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component:  HitboxComponent  = $HitboxComponent
@onready var destroyed_component: DestroyedComponent = $DestroyedComponent


func _ready() -> void:
    visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
    hurtbox_component.hurt.connect(was_hit)
    hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))

func was_hit(hitbox: HitboxComponent) -> void:
    flash_component.flash()
    scale_component.tween_scale()
    shake_component.tween_shake()
    

