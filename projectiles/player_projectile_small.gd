extends Node2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scale_component: ScaleComponent   = $ScaleComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent


func _ready() -> void:
    scale_component.tween_scale()
    visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
    hitbox_component.hit_hurtbox.connect(hit_target)


func hit_target(hurtbox: HurtboxComponent) -> void:
    queue_free()
