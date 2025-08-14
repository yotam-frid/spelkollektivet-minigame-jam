extends Node

@export var empty_texture: Texture2D
@export var questions_slide: Texture2D
@export var slides: Array[Texture2D]
@export var slide_queue: Array[Texture2D]
@export var slide_rects: Array[TextureRect]
@export var big_slide: Sprite2D

signal on_change_slide
var last_pitch = 1.0
var can_remove : bool = true
func _ready() -> void:
	slide_queue.resize(randi_range(22, 25))
	for i in range(slide_queue.size()):
		slide_queue.set(i, slides.pick_random())
	slide_queue.append(questions_slide)
	match_rects_to_queue()
	CurrentGame.instance.clear_timer()
	
func on_timer_go_over() -> void:
	$"lose sound".play()
	CurrentGame.instance.finish(2.0)
	can_remove = false
func match_rects_to_queue() -> void:
	var prev_slide = big_slide.texture
	$"../slide/slide particle".texture = prev_slide
	$"../slide/slide particle".restart()
	if len(slide_queue) > 0:
		big_slide.texture = slide_queue.pop_front()
	for i in range(slide_rects.size()):
		if i < len(slide_queue):
			slide_rects[i].texture = slide_queue[i]
		else:
			slide_rects[i].texture = empty_texture
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spacebar") and can_remove:
		remove_from_queue()

func check_win():
	if slide_queue.size() == 0:
		CurrentGame.instance.win_and_finish(2.8)
		print("YOU WIN :)")
		$"win sound".play()
		$"../CONFETTI HOLDER/confetti".emitting = true
		$"../CONFETTI HOLDER/confetti2".emitting = true
		can_remove = false
	# DO WIN THINGS, PLAY THE "uhehemememm guy...?"
func remove_from_queue() -> void:
	# POP THE FRONT AND MAKE IT DISAPPEAR BY FLYING OFF
	# SWITCH THE PRESENTER SPRITE TOO
	on_change_slide.emit()
	play_slide()
	match_rects_to_queue()
	check_win()

func play_slide():
	randomize()
	var pitch_scale = randf_range(0.8, 1.2)
	
	while abs(pitch_scale - last_pitch) <.1:
		randomize()
		pitch_scale = randf_range(0.8, 1.2)
		
	last_pitch = pitch_scale
	$slide.pitch_scale = pitch_scale
	$slide.play()
	
