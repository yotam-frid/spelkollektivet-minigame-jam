extends RigidBody2D
class_name PlayerDropFrog

@export var merge_result: RigidBody2D
@export var merge_target: Area2D

var dropped = false
var merged = false
@export var can_merge = false
@export var next_frog: PlayerDropFrog
@export var next_frog_indicator: Sprite2D
@export var end_label: Label

var min_x = 318
var max_x = 640

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	freeze = true
	merge_target.body_entered.connect(_on_area_entered)
	if next_frog != null:
		next_frog.hide()
		next_frog.collision_layer = 0
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		drop()

func drop():
	if dropped or not visible:
		return
	dropped = true
	freeze = false
	$SndDrop.play()
	$Line.hide()
	
func merge():
	if merged or not can_merge:
		return
		
	CurrentGame.instance.win()
	merged = true
	merge_result.show()
	merge_result.sleeping = false
	
	var midpoint = (global_position + merge_target.global_position) / 2.0
	merge_result.global_position = midpoint
	global_position = Vector2.ZERO
	freeze = true
	
	hide()
	merge_target.queue_free()
	
	merge_result.freeze = false
		# Wait a few physics frames to ensure the body is fully active

	merge_result.apply_central_impulse(Vector2.UP * 200)
	merge_result.get_node("GPUParticles2D").restart()
	$SndMerge.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not dropped and visible:
		var mouse_pos = get_viewport().get_mouse_position()
		global_position.x = clampf(mouse_pos.x, min_x, max_x)

func _on_area_entered(body: Node2D):
	if body == self:
		call_deferred("merge")
	


func _on_body_entered(_body: Node) -> void:
	if next_frog != null and not can_merge:
		if next_frog.visible:
			return
		next_frog.show()
		next_frog.collision_layer = collision_layer
		
		next_frog_indicator.hide()
		end_label.show()
	
