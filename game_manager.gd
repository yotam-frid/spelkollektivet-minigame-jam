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
@onready var levelup: AudioStreamPlayer = $Levelup

var music_volume: float = 0.3
var level = 1
var lives = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.play()
	music.volume_linear = music_volume
	GlobalSong.change_bpm(152)
	Engine.time_scale = 1.0
	await get_tree().create_timer(2.0).timeout
	create_new_minigame_queue()
	next_minigame()

###############
## Game Loop ##
###############
func next_minigame():
	if minigame_queue.size() == 0:
		CurrentGame.lost = false
		await screen_game_over()
		return
		
	current_minigame_won = false # Reset state
	
	print("Preparing next minigame")
	await prepare_next_minigame()
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
	
	if not current_minigame_won:
		lives -= 1
	else:
		CurrentGame.score += 1
		
	var lost = lives == 0
	print("Game finished, won: " + str(current_minigame_won))
	ui.finish_game(current_minigame, current_minigame_won)
	if not lost:
		music_restore()
	
	await ui.minigame_zoomed_out
	unload_current_minigame()
	await ui.ready_for_next_minigame
	
	if not lost:
		next_minigame()
	else:
		CurrentGame.lost = true
		await screen_game_over()
		
func screen_game_over():
	music_mute()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://win.tscn")
	
func on_minigame_timer_started():
	ui.show_ingame_ui(current_minigame)
	
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
	if level == 2:
		minigame_queue = minigame_queue.slice(0, 5)
	
func prepare_next_minigame():
	if minigame_queue.size() == 0:
		CurrentGame.lost = true
		await screen_game_over()
		return
		#if level == 1:
			#await increase_level()
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
	
func increase_level():
	music_mute()
	levelup.play()
	await ui.display_text("FASTER!", 2.0)
	music.stop()
	await ui._create_ui_timer(1.0)
	
	level += 1
	Engine.time_scale = 1.2
	
	music.pitch_scale = Engine.time_scale
	GlobalSong.change_bpm(GlobalSong.bpm * Engine.time_scale)
	music.play()
	music_restore()
	await ui._create_ui_timer(2.0)
	
func finish_game():
	print("The end!") 
