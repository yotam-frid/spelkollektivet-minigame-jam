extends Node2D

var waiting_for_signal = false
var can_click = false

@export var min_wait_time = 2.0
@export var max_wait_time = 4.0
@export var reaction_window = 0.5

func _ready():
	$signal_timer.one_shot = true
	$window_timer.one_shot = true
	start_waiting()
	
func start_waiting():
	can_click = false
	waiting_for_signal = true
	$Label.text = "Grab seconds..."
	# Tiempo random hasta la señal
	$signal_timer.start(randf_range(min_wait_time,max_wait_time))

func _on_window_timer_timeout():
	if can_click:
		lose_game()

func _input(event):
	if event.is_action_pressed("left_click"):
		if can_click:
			win_game()
		elif waiting_for_signal:
			lose_game()

func win_game():
	can_click = false
	$Label.text = "OM ÑOM ÑOM"
	CurrentGame.instance.win()


func lose_game():
	can_click = false
	$Label.text = "No more lasagna... :c"
	CurrentGame.instance.game_finished


func _on_signal_timer_timeout():
	pass # Replace with 	waiting_for_signal = false
	can_click = true
	$Label.text = "NOW!"
	$window_timer.start(reaction_window) #tiempo para reaccionarfunction body.
