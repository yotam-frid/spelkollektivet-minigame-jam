class_name Troll2D extends TextureRect


var minigame : Minigame

func _init( game : TrollMinigame) -> void:
	minigame = game

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and not event.is_echo() and event.button_index == MOUSE_BUTTON_LEFT:
			minigame.win_and_finish()
			
