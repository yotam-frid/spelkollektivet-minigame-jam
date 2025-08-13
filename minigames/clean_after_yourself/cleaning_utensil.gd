extends Node2D

@export var toilet: Sprite2D
@export var plate: Sprite2D

@export var brush: Sprite2D
@export var hand: Sprite2D
@export var handDirty: Sprite2D
@export var sponge: Sprite2D

@export var mouseDetectionQuickFix: Node2D

@export var numberOfPoopsToClean: int = 6

var isToiletActive: bool = true
var isHandDirty: bool = false
var isHoldingBrush: bool = false


var reducePoopBrushAlpha: float = 0.34
var reducePoopHandAlpha: float = 0.10
var numberOfCleanedPoops: int = 0

func _ready() -> void:
	set_toillet_active(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion_ev: InputEventMouseMotion = event
		mouseDetectionQuickFix.position = motion_ev.global_position
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if isHoldingBrush:
				brush.position = motion_ev.global_position
			else:
				if isHandDirty:
					handDirty.position = motion_ev.global_position
				else:
					hand.position = motion_ev.global_position
				
	if event is InputEventMouseButton:
		var button_ev: InputEventMouseButton = event
		if button_ev.button_index == MOUSE_BUTTON_LEFT and button_ev.pressed:
			if isHoldingBrush:
				hide_hands()
		if button_ev.is_released():
			hide_hands()

func set_toillet_active(active: bool) -> void:
	isToiletActive = active
	if isToiletActive:
		toilet.show()
		plate.hide()
		brush.show()
		sponge.hide()

	else:
		toilet.hide()
		plate.show()
		brush.hide()
		sponge.show()

func hide_hands() -> void:
	hand.position = Vector2(-100, -100)
	handDirty.position = Vector2(-100, -100)

func check_if_game_is_won() -> void:
	if numberOfCleanedPoops >= numberOfPoopsToClean:
		# Emit a signal or call a function to indicate the game is won
		CurrentGame.instance.win_and_finish()

func _on_mouse_hold_area_mouse_exited() -> void:
	#isHoldingBrush = false
	pass

func _on_mouse_hold_area_mouse_entered() -> void:
	#isHoldingBrush = true
	pass

func _on_mouse_hold_area_area_entered(area: Area2D) -> void:
	if area.get_groups().has("Poop"):
		var parent: Node2D = area.get_parent()
		if parent is Sprite2D:
			if parent.modulate.a > 0:
				parent.modulate.a -= reducePoopBrushAlpha
				if parent.modulate.a <= 0:
					parent.modulate.a = 0
					numberOfCleanedPoops += 1
					check_if_game_is_won()

func _on_hand_area_2d_area_entered(area: Area2D) -> void:
	# only do this if the mouse is pressed
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if area.get_groups().has("Poop"):
			var parent: Node2D = area.get_parent()
			if parent is Sprite2D:
				if parent.modulate.a > 0:
					isHandDirty = true
					hand.position = Vector2(-100, -100)
					parent.modulate.a -= reducePoopHandAlpha
					if parent.modulate.a <= 0:
						parent.modulate.a = 0
						numberOfCleanedPoops += 1
						check_if_game_is_won()


func _on_mouse_detection_quick_fix_area_entered(area: Area2D) -> void:
	if area.get_groups().has("Handle"):
		isHoldingBrush = true

func _on_mouse_detection_quick_fix_area_exited(area: Area2D) -> void:
	if area.get_groups().has("Handle"):
		isHoldingBrush = false
