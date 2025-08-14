extends Node

var instance: Minigame = null

# Putting some global state here  because I'm lazy as hell
var score = 0
var lost = false

func _init():
	var default_instance: Minigame = Minigame.new()
	default_instance.difficulty = 1
	default_instance.is_in_game_manager = false
	
	instance = default_instance

## Notifies that a win condition was met.
func win():
	instance.win()

func set_instance(minigame: Minigame):
	instance = minigame
	
func clear_instance():
	instance = null

func reset():
	score = 0
	lost = false
