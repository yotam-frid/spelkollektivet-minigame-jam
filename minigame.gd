extends Node
class_name Minigame

signal game_win
signal game_finish

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

## Call this to let the Game Manager know the minigame has been won!
func win():
	game_win.emit()

func _enter_tree() -> void:
	# Wait duration
	if not Engine.is_editor_hint():
		await get_tree().create_timer(duration).timeout
		game_finish.emit()
