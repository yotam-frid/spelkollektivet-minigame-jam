@tool
extends AnimatedSprite2D
class_name MunchyAnimatedSprite2D

@export var up: MunchyAnimatedSprite2D
@export var left: MunchyAnimatedSprite2D
@export var right: MunchyAnimatedSprite2D
@export var down: MunchyAnimatedSprite2D

@export var sound: AudioStreamPlayer

@export var is_first: bool
@export var play_on_start: bool = true


signal activated

var is_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centered = false
	if not Engine.is_editor_hint():
		if play_on_start:
			play()
		show()
		if is_first:
			activate()
		else:
			disable()


func _input(event: InputEvent) -> void:
	if not is_active:
		return
		
	if event.is_action_pressed("up") and up != null:
		switch(up)
	if event.is_action_pressed("left") and left != null:
		switch(left)
	if event.is_action_pressed("right") and right != null:
		switch(right)
	if event.is_action_pressed("down") and down != null:
		switch(down)
		
func activate():
	self_modulate = Color.WHITE
	activated.emit()
	is_active = true
	
	if sound != null:
		sound.play()
		
	if not play_on_start:
		play()
	
func disable():
	self_modulate = Color(Color.WHITE, 0)
	is_active = false
	
func switch(target: MunchyAnimatedSprite2D):
	disable()
	target.activate()
