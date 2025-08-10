extends Area2D

@export var take_meatballs: bool
@export var hand: MeatballPickerHand

@onready var meatballs: Node2D = $Meatballs

var ball_amount: int = 0
var in_area = false

signal meatballs_changed(amount: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if take_meatballs:
		ball_amount = meatballs.get_children().size()
	else:
		for m: Node2D in meatballs.get_children():
			m.hide()
			
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _on_area_entered(_area: Area2D):
	in_area = true
	
func _on_area_exited(_area: Area2D):
	in_area = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and in_area and take_meatballs and !hand.has_meatball:
		change_meatballs()
	if event.is_action_released("left_click") and in_area and !take_meatballs and hand.has_meatball:
		change_meatballs()

func change_meatballs():
	if take_meatballs:
		if ball_amount == 0:
			return
			
		var ball: Node2D = meatballs.get_child(ball_amount - 1)
		ball.hide()
		ball_amount -= 1
		meatballs_changed.emit(ball_amount)
		hand.toggle_meatball(true)
	else:
		var ball: Node2D = meatballs.get_child(ball_amount)
		ball.show()
		ball_amount += 1
		meatballs_changed.emit(ball_amount)
		hand.toggle_meatball(false)
