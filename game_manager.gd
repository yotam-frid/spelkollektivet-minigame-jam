extends Node
class_name GameManager

@export var ui: UI
@export var shuffle: bool = true
@export var minigame_scenes: Array[PackedScene]

var minigame_queue: Array[PackedScene]
var current_minigame: Minigame = null
var current_minigame_won = false
var is_current_minigame_in_tree = false

@onready var music: AudioStreamPlayer = $Bgmusic
var music_volume: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.play()
	music.volume_linear = music_volume
	GlobalSong.change_bpm(128)
	await get_tree().create_timer(2.0).timeout
	next_minigame()

###############
## Game Loop ##
###############
func next_minigame():
	current_minigame_won = false # Reset state
	
	print("Preparing next minigame")
	prepare_next_minigame()
	ui.set_won(false)
	
	print("Showing intro")
	await ui.show_minigame_intro(current_minigame)
	ui.start_game(current_minigame)
	
	await get_tree().process_frame
	await ui.minigame_zoomed_in
	current_minigame.start_timer()
	
func on_minigame_finished():
	# Wait 1 frame to let any logic run
	await get_tree().process_frame
	music_restore()
	
	print("Game finished, won: " + str(current_minigame_won))
	ui.finish_game(current_minigame, current_minigame_won)
	await ui.minigame_zoomed_out
	unload_current_minigame()
	await ui.ready_for_next_minigame
	next_minigame()
	
func on_minigame_timer_started():
	ui.show_ingame_ui(current_minigame)
	music_down()
	
func on_minigame_timer_cleared():
	print("Timer cleared")
	ui.hide_ingame_ui()
	
func on_minigame_music_muted():
	music_mute()
	

#############
## Methods ##
#############
func create_new_minigame_queue():
	minigame_queue = minigame_scenes.duplicate()
	if shuffle:
		minigame_queue.shuffle()
	
func prepare_next_minigame():
	if minigame_queue.size() == 0:
		create_new_minigame_queue()
	
	@warning_ignore("unsafe_method_access")
	current_minigame = minigame_queue.pop_front().instantiate()
	current_minigame.game_won.connect(on_minigame_won)
	current_minigame.game_finished.connect(on_minigame_finished)
	current_minigame.timer_started.connect(on_minigame_timer_started)
	current_minigame.timer_cleared.connect(on_minigame_timer_cleared)
	current_minigame.music_muted.connect(on_minigame_music_muted)
	
	# Expose game on the global scope
	CurrentGame.set_instance(current_minigame)
	
func unload_current_minigame():
	current_minigame.queue_free()
	is_current_minigame_in_tree = false
	
	# Hide from global scope
	CurrentGame.clear_instance()
	
func on_minigame_won():
	if current_minigame_won:
		return
	print("Received win signal")
	current_minigame_won = true
	ui.set_won(true)
	
func music_mute():
	var tween = create_tween()
	tween.tween_property(music, "volume_linear", 0.0, 1.0)
	
func music_restore():
	var tween = create_tween()
	tween.tween_property(music, "volume_linear", music_volume, 1.0)

func music_down():
	#var tween = create_tween()
	#tween.tween_property(music, "volume_linear", music_volume / 2.0, 1.0)
	music_restore()
