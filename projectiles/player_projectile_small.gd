extends Node2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scale_component: ScaleComponent = $ScaleComponent


func _ready() -> void:
    scale_component.tween_scale()
    visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
