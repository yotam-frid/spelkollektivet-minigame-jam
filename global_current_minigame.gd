extends Node

var _target: Minigame = null

var difficulty: int:
	get():
		_assert_target_exists()
		return _target.difficulty
	set(_value):
		printerr("Can't change difficulty from Global Scope.")

func win():
	_assert_target_exists()
	_target.win()

func set_target(minigame: Minigame):
	_target = minigame
	
func clear_target():
	_target = null

func _assert_target_exists():
	# This will throw an error if _target is null
	assert(_target != null)
