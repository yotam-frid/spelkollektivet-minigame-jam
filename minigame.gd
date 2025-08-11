extends Node
class_name Minigame

signal game_won
signal game_finished
signal timer_cleared

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

var _timer_cleared = false

## Signals that the game has been won.
func win():
	game_won.emit()
	
## Signals to end the game and return to the main screen.
##
## This will be called automatically unless [code]clear_timer()[/code] has been called.
func finish():
	if is_finished:
		return
		
	is_finished = true
	game_finished.emit()
	
## Signals that the game has been won, cancels the running game timer,
## and returns to the main screen after a delay (2 seconds by default, if not provided.)
func win_and_finish(wait_seconds: float = 2.0):
	if is_finished:
		return
		
	win()
	clear_timer()
	await get_tree().create_timer(wait_seconds).timeout
	finish()
	
## Clears the default minigame countdown timer, and hides the timer UI.
## If you use this, you MUST call [code]finish()[/code] manually, otherwise
## the game will be stuck!
func clear_timer():
	if is_finished or _timer_cleared:
		return
		
	_timer_cleared = true
	timer_cleared.emit()

func _enter_tree() -> void:
	# Wait duration
	if not Engine.is_editor_hint():
		await get_tree().create_timer(duration).timeout
		if not _timer_cleared:
			finish()
