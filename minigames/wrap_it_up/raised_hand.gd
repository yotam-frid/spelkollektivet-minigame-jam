extends TextureRect

func _ready() -> void:
	CurrentGame.instance.game_won.connect(_raise)

func _raise() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel(true)
	var time = 0.9
	tween.tween_property($".", "position:y", position.y - 350, time)
