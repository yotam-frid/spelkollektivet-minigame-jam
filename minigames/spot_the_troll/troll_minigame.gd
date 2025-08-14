class_name TrollMinigame extends Minigame

@export var layers : Array[TrollLayer]

const trolls : Array[CompressedTexture2D] = [preload("uid://c3is5rvakkqo"),preload("uid://csvc65sdmk8h"),preload("uid://csq7ag2kkn70x"),preload("uid://cs4x1ct3we062")]
const rocks : Array[CompressedTexture2D] = [preload("uid://bsjn1m0wh45pd"),preload("uid://jbe8x18wrlnb"),preload("uid://c2pmt2yh36gb7"),preload("uid://bjhhao7pgcjh4")]

func _ready() -> void:
	
	
	var number_of_rocks = 0
	var troll_types = 0
	
	#spawn the trolls!!
	match(difficulty):
		1: 
			number_of_rocks = randi() % 10 + 5
			troll_types = 1
		2: 
			number_of_rocks = randi() % 20 + 12
			troll_types = 3
		3: 
			number_of_rocks = randi() % 25 + 20
			troll_types = 4
		
	var third = number_of_rocks / 3
	var troll_num = randi() % (number_of_rocks -1) 
	var layer = 0
	var i = 0
	
	while(i < number_of_rocks):
		
		var rock
		
		if(i == troll_num):
			rock = Troll2D.new(self)
			rock.texture = trolls[randi()%troll_types-1]
		else:
			rock = Sprite2D.new()
			rock.texture = rocks[randi()%troll_types-1]
			
		
			
		if(i > third):
			layer += 1
			third *= 2
		
		layers[layer].add_troll(rock)
		
		i += 1
	
	start_timer()
