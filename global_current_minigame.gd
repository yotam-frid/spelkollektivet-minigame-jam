extends Node

var instance: Minigame = null

func _init():
	var default_instance: Minigame = Minigame.new()
	default_instance.difficulty = 1
	
	instance = default_instance

## Notifies that a win condition was met.
func win():
	instance.win()

func set_instance(minigame: Minigame):
	instance = minigame
	
func clear_instance():
	instance = null
