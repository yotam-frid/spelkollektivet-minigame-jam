extends Node2D
class_name LogoFaceUI

@onready var sprite: AnimatedSprite2D = $SpelFace
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var game_won = false
var animate_end = false

func _ready() -> void:
	GlobalSong.animate_on_beat(self, "position", Vector2.DOWN * 4, true)
	

func reset():
	game_won = false
	animate_end = false
	sprite.play("default")
	animation_player.play("RESET")
	
	
func show_post_game(won: bool):
	animate_end = true
	game_won = won
	_on_game_end()
	
func _on_game_end():
	# Show
	animate_end = true
	if game_won:
		sprite.play("happy")
		animation_player.play("happy")
	else:
		sprite.play("sad")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animate_end and not game_won:
		sprite.rotation_degrees = -40 + randf_range(-4, 4)
	else:
		sprite.rotation_degrees = 0.0
