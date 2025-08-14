extends Node
@onready var presenter_sprite : Sprite2D = $presenter.child_sprite

@export var presenter_frames : Array[Texture2D]
@export var win_frame : Texture2D
@export var lose_frame : Texture2D

func _ready() -> void:
	CurrentGame.instance.game_won.connect(_on_win)
func _on_switch() -> void:
	presenter_sprite.texture = presenter_frames.pick_random()
func _on_win() -> void:
	presenter_sprite.texture = win_frame
func _on_lose() -> void:
	presenter_sprite.texture = lose_frame
