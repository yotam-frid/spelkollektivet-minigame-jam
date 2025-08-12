extends Sprite2D
class_name BeatSprite2D

@export var beat_position_add: Vector2 = Vector2.ZERO
@export var beat_scale_target: Vector2 = Vector2.ONE
@export var beat_delay: float = 0.0

var child_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child_sprite = Sprite2D.new()
	child_sprite.texture = texture
	child_sprite.scale = scale
	child_sprite.flip_h = flip_h
	child_sprite.flip_v = flip_v
	child_sprite.frame = frame
	child_sprite.centered = centered
	child_sprite.offset = offset
	
	add_child(child_sprite)
	texture = null
	
	GlobalSong.beat.connect(_on_beat)


func _on_beat():
	if beat_delay > 0.0:
		await get_tree().create_timer(beat_delay).timeout
	var old_position = child_sprite.position
	var old_scale = child_sprite.scale
	
	# Animate
	child_sprite.position += beat_position_add
	child_sprite.scale = beat_scale_target
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true)
	var time = 0.12
	tween.tween_property(child_sprite, "position", old_position, time)
	tween.tween_property(child_sprite, "scale", old_scale, time)
