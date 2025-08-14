extends Sprite2D

@export var the_player: bool = false
@export var you_marker: AnimatedSprite2D
@export var ani_player: AnimationPlayer
@onready var sounds: AudioStreamPlayer = $AudioStreamPlayer2D

var ui_scene: = preload("res://minigames/jugger_rps/scenes/popup_ui.tscn")
var particle_scene: = preload("res://minigames/jugger_rps/scenes/particle.tscn")
var win_sound = preload("res://minigames/jugger_rps/sounds/WinSound.wav")
var lose_sound = preload("res://minigames/jugger_rps/sounds/LoseSound.wav")

var mouse_coords: Vector2
var mouse_sens: float
var clash_state: bool = false
var lerp_speed: float

var is_initialized = false

func _ready() -> void:
	frame = [0,1,2].pick_random()
	ani_player.play("stances")
	you_marker.visible = false

	if the_player == true:
		you_marker.visible = true
		you_marker.play()
	else:
		ani_player.seek(frame + 3, true)
		
	await get_tree().create_timer(1.0).timeout
	is_initialized = true
	mouse_coords = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if not is_initialized:
		return
	if event.is_action_pressed("left_click") && the_player == true && clash_state == false:
		frame = (frame + 1) % 3
		ani_player.seek(frame, true)
	
	#if event.is_action_pressed("right_click") && the_player == false && clash_state == false:
		#frame = (frame + 1) % 3
		#ani_player.seek(frame + 3, true)
		
		
func _physics_process(_delta: float) -> void:
	if not is_initialized:
		return
	if the_player == true: 
		if clash_state == false:
			position.x = position.x + Vector2(get_global_mouse_position() - mouse_coords).x
			mouse_coords = get_global_mouse_position()
		else: 
			position.x -= lerp_speed
			lerp_speed = lerp(lerp_speed, 0.0, 0.25)
		position.x = clamp(position.x, 100, 270)

func bounceback():
	clash_state = true
	lerp_speed = 25.0
	await get_tree().create_timer(0.25).timeout
	clash_state = false
	mouse_coords = get_global_mouse_position()
	
func spawn_particle(anim: String, pos: Vector2):
	var instance: JuggerParticle = particle_scene.instantiate()
	get_parent().add_child(instance)
	instance.ani_player.play("hit_spark")
	instance.position = pos
	instance.rotation = randf() * PI

func _on_hitbox_body_area_entered(area: Area2D) -> void:
	if area.name == "HitboxSword" && the_player == true:
		var instance_x: PopupUI = ui_scene.instantiate()
		var instance_lose: PopupUI = ui_scene.instantiate()
		
		get_parent().add_child(instance_x)
		instance_x.ani_player.play("x_marker", true)
		var pos_array: Array = [-10, 10, 20]
		instance_x.position = $HitboxBody.global_position + Vector2(-5, pos_array[frame])
		
	
		get_parent().add_child(instance_lose)
		instance_lose.ani_player.play("you_lose", true)
		instance_lose.position = Vector2(350, 88)
		sounds.stream = lose_sound
		sounds.play()
		clash_state = true
		

func _on_hitbox_sword_area_entered(area: Area2D) -> void:
	if the_player == true:
		if area.name == "HitboxBody":
			CurrentGame.instance.win()
			var instance: PopupUI = ui_scene.instantiate()
			get_parent().add_child(instance)
			instance.ani_player.play("you_win", true)
			instance.position = Vector2(350, 88)
			clash_state = true
			sounds.stream = win_sound
			sounds.play()

			
			
		if clash_state == false && area.name == "HitboxSword":
			bounceback()
			var pos_array: Array = [10,20,-13]
			spawn_particle("hit_spark", area.global_position + Vector2(-45, pos_array[frame]))
			sounds.play()
			
