extends Node
class_name Minigame

signal game_win
signal game_finish
signal unloading

## The duration of the minigame in seconds.
@export var duration: int = 5
@export var viewport_texture_filter: Viewport.DefaultCanvasItemTextureFilter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR

@export_category("Intro")
## Instruction text shown before the game starts.
@export var instruction = ""
## Possible mouse inputs that are shown before the game starts.
@export_flags("Movement", "Left Click", "Right Click") var mouse: int
## Possible keyboard inputs that are shown before the game starts.
@export_flags("WASD/Arrows", "Spacebar", "Full Keyboard") var keyboard: int

## Value from 1-3 set by the game manager. Can be used to increase difficulty.
var difficulty: int = 1

var is_finished = false

## Signals that the game has been won.
func win():
	game_win.emit()
	
## Signals to end the game early.
func finish():
	if is_finished:
		return
		
	is_finished = true
	game_finish.emit()

func _enter_tree() -> void:
	# Wait duration
	if not Engine.is_editor_hint():
		await get_tree().create_timer(duration).timeout
		finish()
		
func unload_resources():
	unloading.emit()
