extends Sprite2D

class_name JuggerParticle

@export var ani_player: AnimationPlayer

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
