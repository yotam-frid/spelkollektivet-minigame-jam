extends Area2D
class_name MeatballPickerHand

var has_meatball = false
var disabled = false

func toggle_meatball(on: bool):
	has_meatball = on
	$Pivot/Meatball.visible = on
	if on:
		$TakeSfx.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_meatball(false)
	GlobalSong.animate_on_beat($Pivot, "position", Vector2.DOWN * 4, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not disabled:
		var mouse_pos = get_viewport().get_mouse_position()
		global_position = mouse_pos
		global_position.y = max(global_position.y, 70)
