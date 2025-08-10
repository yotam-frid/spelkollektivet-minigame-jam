extends Area2D
class_name MeatballPickerHand

var has_meatball = false

func toggle_meatball(on: bool):
	has_meatball = on
	$Meatball.visible = on

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_meatball(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	global_position = mouse_pos
