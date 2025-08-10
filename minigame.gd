extends Node
class_name Minigame

signal game_won
signal game_finished

## Instruction text shown before the game starts.
@export var title = ""
## The duration of the minigame in seconds.
@export var duration: int = 5

@export_category("Viewport")
## Increases the stretch zoom of the viewport, useful for pixelart minigames.
@export var viewport_zoom: int = 1
## Disable to use nearest-neighbor filtering, which better for pixelart minigames.
@export var viewport_texture_filter: bool = true

@export_category("Controls")
## Possible mouse inputs that are shown before the game starts.
@export_flags("Movement", "Left Click", "Right Click") var mouse: int
## Possible keyboard inputs that are shown before the game starts.
@export_flags("WASD/Arrows", "Spacebar", "Full Keyboard") var keyboard: int

## Value from 1-3 set by the game manager. Can be used to increase difficulty.
var difficulty: int = 1

var is_finished = false
var is_in_game_manager = true

## Signals that the game has been won.
func win():
	game_won.emit()
	
## Signals to end the game early.
func finish():
	if is_finished:
		return
		
	is_finished = true
	game_finished.emit()

func _enter_tree() -> void:
	# Wait duration
	if not Engine.is_editor_hint():
		await get_tree().create_timer(duration).timeout
		finish()
