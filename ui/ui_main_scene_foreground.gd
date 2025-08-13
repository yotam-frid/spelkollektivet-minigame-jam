extends Control
class_name MainSceneForegroundUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var logo_face: LogoFaceUI = $LogoFace

signal opened
signal zoomed
signal closed

var opening = false

func reset():
	logo_face.reset()
	#pass
	
func show_post_game(won: bool):
	logo_face.show()
	logo_face.show_post_game(won)
	#pass
	
func show_intro():
	logo_face.hide()
	#pass

func open():
	animation_player.play("open", -1, 1.0, false)
	opening = true
	
func close():
	animation_player.play("open", -1, -2.0, true)
	opening = false
	
func zoom():
	animation_player.play()

func _on_tv_zoom():
	zoomed.emit()
	
func _on_curtains_opened():
	if opening:
		animation_player.pause()
		opened.emit()	

func _on_close():
	closed.emit()
