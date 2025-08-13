extends Node2D
class_name LifeIndicator

var beat_counter = 0
var dead = false
var shake_amount = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_reset_pos: Vector2 = sprite.position
@onready var crack: Sprite2D = $AnimatedSprite2D/Crack
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSong.animate_on_beat(self, "position", Vector2.DOWN * 10, true)
	GlobalSong.beat.connect(_on_beat)
	
func set_homie(homie_index: int):
	sprite.frame = homie_index

func _on_beat():
	if dead: 
		return
	beat_counter += 1
	if beat_counter == 2:
		rotate_to(18)
	if beat_counter == 4:
		rotate_to(0)
		beat_counter = 0

func rotate_to(deg: float):
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees", deg, 0.06)
	
func _process(delta: float):
	if shake_amount > 0.0:
		shake_amount = max(shake_amount-delta, 0.0)
		sprite.position = sprite_reset_pos + \
			Vector2(randf_range(-1, 1), randf_range(-.2, 2)) * (5.0 if not dead else 10.0)

func shake(amount: float):
	shake_amount = amount

func lose_life():
	if dead:
		return
	
	shake(0.4)
	dead = true
	crack.show()
	GlobalSong.clear_animations(self)
	rotate_to(-4)
	await get_tree().create_timer(0.5).timeout
	animation_player.play("fall")
