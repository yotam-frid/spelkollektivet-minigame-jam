extends Node2D

var waiting_for_signal = false
var can_click = false

@export var min_wait_time = 2.0
@export var max_wait_time = 4.0
@export var reaction_window = 0.5

@onready var camera: Camera2D = $Camera2D

func _ready():
	CurrentGame.instance.clear_timer()
	start_waiting()
	GlobalSong.animate_on_beat($Label, "position", Vector2.DOWN * 10, true)
	
	
func start_waiting():
	can_click = false
	waiting_for_signal = true
	$Label.text = "12:29"
	# Tiempo random hasta la señal
	$signal_timer.start(randf_range(min_wait_time,max_wait_time))

func _on_window_timer_timeout():
	if can_click:
		lose_game()

func _input(event):
	if event.is_action_pressed("left_click") || event.is_action_pressed("spacebar"):
		if can_click:
			win_game()
		elif waiting_for_signal:
			lose_game()

func win_game():
	can_click = false
	$AnimatedSprite2D.play("Won")
	$AnimatedSprite2D.scale = Vector2(4,4)
	$Label.text = "NECTAR!"
	$AnimationPlayer.play("win_camara")
	CurrentGame.instance.win_and_finish(2.0)


func lose_game():
	can_click = false
	$Label.text = "No more lasagna... :c"
	$AnimatedSprite2D.play("Lost_pre")
	$AnimatedSprite2D.scale = Vector2(4,4)
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("Lost")
	await get_tree().create_timer(2.0).timeout
	
	CurrentGame.instance.finish()


func _on_signal_timer_timeout():
	waiting_for_signal = false
	can_click = true
	$Label.text = "12:30"
	$AnimatedSprite2D.scale = Vector2(4,4)
	$AnimatedSprite2D.play("1230")
	$window_timer.start(reaction_window) #tiempo para reaccionarfunction body.
