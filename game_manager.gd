extends Node
class_name GameManager

@export var ui: UI
@export var shuffle: bool = true
@export var minigame_scenes: Array[PackedScene]

var minigame_queue: Array[PackedScene]
var current_minigame: Minigame = null
var current_minigame_won = false
var is_current_minigame_in_tree = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
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
	print("Hiding intro")
	ui.hide_minigame_intro()
	
	print("Showing game")
	ui.show_minigame_viewport(current_minigame)
	
	await get_tree().process_frame
	print("Starting timer: " + str(current_minigame.duration) + " seconds")
	current_minigame.start_timer()
	
func on_minigame_finished():
	# Wait 1 frame to let any logic run
	await get_tree().process_frame
	
	print("Game finished, won: " + str(current_minigame_won))
	await ui.hide_minigame_viewport()
	
	print("Unloading game")
	ui.clear_viewport()
	unload_current_minigame()
	
	print("Showing inbetween")
	await ui.inbetween()
	next_minigame()
	
func on_minigame_timer_cleared():
	print("Timer cleared")
	ui.hide_ingame_ui()
	

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
	current_minigame.timer_cleared.connect(on_minigame_timer_cleared)
	
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
