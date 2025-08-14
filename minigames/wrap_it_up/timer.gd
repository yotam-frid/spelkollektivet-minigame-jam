extends TextureRect

var max_seconds : float = 300
var current_timer : float = 0
var time_elapsed : float = 0.0
var keep_adding : bool = true
@export var time_label : Label
@export var progress_bar : TextureProgressBar

signal timer_go_over

func _format_seconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)

	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]

	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	
func _ready():
	current_timer = max_seconds - (CurrentGame.instance.duration + 1)
	CurrentGame.instance.game_won.connect(_on_win)
	timer_go_over.connect(_go_over)
	
func _process(delta: float) -> void:
	if keep_adding:
		current_timer += delta
		time_label.text = _format_seconds(current_timer, false)
		progress_bar.value = inverse_lerp(50.0, max_seconds, current_timer)
		if current_timer >= max_seconds:
			timer_go_over.emit()
func _go_over() -> void:
	print("YOU LOSE:()")
	$AnimationPlayer.speed_scale = 3.0
	$AnimationPlayer.play("timer_shake")
	keep_adding = false
	
func _on_win() -> void:
	# go down n stop counting
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel(true)
	var time = 0.9
	tween.tween_property($".", "position:y", position.y + 300, time)
	keep_adding = false
