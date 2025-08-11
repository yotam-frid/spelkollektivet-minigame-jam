extends Node

signal beat

var bpm = 134.0

var beat_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beat_timer = Timer.new()
	beat_timer.timeout.connect(_on_beat_timer_timeout)
	beat_timer.ignore_time_scale = true
	add_child(beat_timer)
	
	start()


func start():
	beat_timer.wait_time = 60.0 / bpm
	beat_timer.start()


func _on_beat_timer_timeout() -> void:
	beat.emit()
