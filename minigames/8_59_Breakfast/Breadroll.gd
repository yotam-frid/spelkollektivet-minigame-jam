extends RigidBody2D
class_name Breadroll

func _ready() -> void:
	print("body.breadrooll: ", name)
	set_global_scale(Vector2.ONE * randf())
	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		print("Collided with:", body.name)
		if freeze:
			var direction = (body.global_position - global_position).normalized()
			body.linear_velocity = direction * 500 + Vector2.UP * 100
			body.angular_velocity = 0
		else: 
			body.linear_velocity = linear_velocity
