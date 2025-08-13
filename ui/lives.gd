extends Control
class_name LivesUI

const SCENE = preload("res://ui/life_indicator.tscn")
var width: float = 580.0

const TOTAL_HOMIES = 24
var amount_left: int = -1

var indicators: Array[LifeIndicator]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func init_lives(count: int):
	amount_left = count
	
	# Generate random homies	
	var homie_indices := _generate_random_homie_indices(count)
	
	# Initialize indicators
	for c in get_children():
		if c is LifeIndicator:
			var ind: LifeIndicator = c
			ind.set_homie(homie_indices.pop_front())
			indicators.append(ind)
			
		
	assert(amount_left == indicators.size())

func _generate_random_homie_indices(amount: int) -> Array:
	var numbers: Array = Array(range(TOTAL_HOMIES))
	numbers.shuffle()
	return numbers.slice(0, amount)

func lose_life():
	indicators[amount_left-1].lose_life()
	amount_left -= 1
