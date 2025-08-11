extends Control
class_name MainSceneForegroundUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal zoomed
signal closed

func open():
	animation_player.play("open", -1, 2.0, false)
	
func close():
	animation_player.play("open", -1, -2.0, true)

func _on_tv_zoom():
	zoomed.emit()
	
func _on_close():
	closed.emit()
