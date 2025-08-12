extends Node2D
class_name LifeIndicator

var beat_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSong.animate_on_beat(self, "position", Vector2.DOWN * 10, true)
	GlobalSong.beat.connect(_on_beat)

func _on_beat():
	beat_counter += 1
	if beat_counter == 2:
		rotate_to(18)
	if beat_counter == 4:
		rotate_to(0)
		beat_counter = 0

func rotate_to(deg: float):
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees", deg, 0.06)
