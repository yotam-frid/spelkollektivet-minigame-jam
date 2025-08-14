extends Control
class_name BeatControl

@export var beat_position_add: Vector2 = Vector2.ZERO
@export var beat_scale_target: Vector2 = Vector2.ONE
@export var beat_delay: float = 0.0

var child_control : Control
func _ready() -> void:
	GlobalSong.beat.connect(_on_beat)

func _on_beat():
	if beat_delay > 0.0:
		await get_tree().create_timer(beat_delay).timeout

	var old_position = position
	var old_scale = scale
	
	# Animate
	position += beat_position_add
	scale = beat_scale_target
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true)
	var time = 0.12
	tween.tween_property($".", "position", old_position, time)
	tween.tween_property($".", "scale", old_scale, time)
