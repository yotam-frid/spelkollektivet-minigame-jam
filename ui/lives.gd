extends Control
class_name LivesUI

const SCENE = preload("res://ui/life_indicator.tscn")
var width: float = 580.0

var indicators: Array[LifeIndicator]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init_lives(count: int):
	var x = -width / 2.0
	for i in range(count):
		var child = SCENE.instantiate()
		add_child(child)
		child.position = Vector2(x, 0)
		indicators.append(child)
		x += width / float(count-1)
