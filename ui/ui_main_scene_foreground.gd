extends Control
class_name MainSceneForegroundUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var logo_face: LogoFaceUI = $LogoFace

signal zoomed
signal closed

func reset():
	#logo_face.reset()
	pass
	
func show_post_game(won: bool):
	#logo_face.show()
	#logo_face.show_post_game(won)
	pass
	
func show_intro():
	#logo_face.hide()
	pass

func open():
	animation_player.play("open", -1, 2.0, false)
	
func close():
	animation_player.play("open", -1, -4.0, true)

func _on_tv_zoom():
	zoomed.emit()
	
func _on_close():
	closed.emit()
