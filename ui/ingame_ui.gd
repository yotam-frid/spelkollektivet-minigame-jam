extends Control
class_name IngameUI

var max_show_duration: int = 5
var seconds_left: int = 0

func _enter_tree() -> void:
	hide()

func show_for_minigame(minigame: Minigame):
	visible = true
	_setup_countdown(minigame)
	
func _setup_countdown(minigame: Minigame):
	# Get the offset from the minigame's duration
	var duration_offset = minigame.duration - max_show_duration
	
	seconds_left = minigame.duration
	_update_timer_seconds()
	$Timer.start()
	
	if duration_offset > 0:
		# Wait before showing the seconds countdown
		await get_tree().create_timer(duration_offset).timeout
		
	$TimerSeconds.show()


func _on_timer_timeout() -> void:
	seconds_left -= 1
	if seconds_left == 0:
		$Timer.stop()
	_update_timer_seconds()
		
func _update_timer_seconds():
	$TimerSeconds.text = str(seconds_left)


func _on_visibility_changed() -> void:
	if not visible:
		$TimerSeconds.hide()
