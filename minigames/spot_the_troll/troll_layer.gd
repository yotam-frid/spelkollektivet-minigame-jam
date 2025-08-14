class_name TrollLayer extends CanvasLayer

var direction : Vector2
var speed : float

func _ready() -> void:
	direction = Vector2(randf_range(-1,1),randf_range(-0.25,0.25))
	speed = randf_range(50,250)

@export var screen_bounds : Vector2i = Vector2i(960,720)

var trolls : Array[CanvasItem]

func add_troll(troll : CanvasItem):
	add_child(troll)
	trolls.push_back(troll)
	troll.position = Vector2(randi()% screen_bounds.x, randi()% screen_bounds.y)

func _process(delta: float) -> void:
	for troll in trolls:
		troll.position += direction * speed * delta
		if(troll.position.x > screen_bounds.x):
			troll.position = Vector2(0,troll.position.y)
		if(troll.position.x < 0):
			troll.position = Vector2(screen_bounds.x,troll.position.y)
		
		if(troll.position.y > screen_bounds.y):
			troll.position = Vector2(troll.position.x,0)
		if(troll.position.y < 0):
			troll.position = Vector2(troll.position.x, screen_bounds.y)
