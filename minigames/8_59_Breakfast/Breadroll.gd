extends RigidBody2D
class_name Breadroll

func _ready() -> void:
	print("Scaling applied to", name)
	var new_scale = Vector2.ONE * .8 + Vector2.ONE * .4 * randf()
	$Sprite2D.scale = new_scale
	$Shape.scale = new_scale
	$Shape2.scale = new_scale
	
