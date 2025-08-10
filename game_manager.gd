extends Node
class_name GameManager

@export var ui: UI

@export var minigame_scenes: Array[PackedScene]
@export var preloader: ResourcePreloader

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
	
	print("Showing intro")
	await ui.show_minigame_intro(current_minigame)
	print("Hiding intro")
	ui.hide_minigame_intro()
	
	print("Showing game")
	ui.show_minigame_viewport(current_minigame)
	
func on_minigame_finished():
	print("Game finished, won: " + str(current_minigame_won))
	await ui.hide_minigame_viewport()
	
	print("Unloading game")
	ui.clear_viewport()
	unload_current_minigame()
	
	print("Showing inbetween")
	await ui.inbetween()
	next_minigame()
	

#############
## Methods ##
#############
func create_new_minigame_queue():
	minigame_queue = minigame_scenes.duplicate()
	minigame_queue.shuffle()
	
func prepare_next_minigame():
	if minigame_queue.size() == 0:
		create_new_minigame_queue()
	
	current_minigame = minigame_queue.pop_front().instantiate()
	current_minigame.game_win.connect(on_minigame_won)
	current_minigame.game_finish.connect(on_minigame_finished)
	
	# Expose game on the global scope
	CurrentGame.set_instance(current_minigame)
	
func unload_current_minigame():
	current_minigame.unload_resources()
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
