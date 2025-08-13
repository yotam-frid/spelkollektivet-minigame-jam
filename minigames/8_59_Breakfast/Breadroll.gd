extends RigidBody2D
class_name Breadroll

func _ready() -> void:
	set_global_scale(Vector2.ONE * randf())
