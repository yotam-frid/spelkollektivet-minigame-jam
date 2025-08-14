extends Button

var character = ""
var hue = 0.0
var hue_speed = 0.2
var hue_speed_won = 0.5
var outline_style_normal = StyleBoxFlat.new()
var outline_style_hover = StyleBoxFlat.new()
var outline_style_pressed = StyleBoxFlat.new()
var highlighted = false
var bg_color_normal = Color(1,1,1)
var bg_color_hover = Color(1,1,1)
var bg_color_pressed = Color(1,1,1)
var character_color = Color(1,1,1)
var collision_size_normal = Vector2(64, 64)
var collision_size_highlighted = collision_size_normal + Vector2(24, 24)
var collision_outline = 128
var collision_position = Vector2(0, 0)

func _ready():
	var thickness = 3
	outline_style_normal.border_width_left = thickness
	outline_style_normal.border_width_top = thickness
	outline_style_normal.border_width_right = thickness
	outline_style_normal.border_width_bottom = thickness
	outline_style_hover.border_width_left = thickness
	outline_style_hover.border_width_top = thickness
	outline_style_hover.border_width_right = thickness
	outline_style_pressed.border_width_bottom = thickness
	outline_style_pressed.border_width_left = thickness
	outline_style_pressed.border_width_top = thickness

func _process(delta):
	hue += delta * hue_speed  # speed of hue change
	if(hue < 0.0):
		hue += 1.0
	elif(hue > 1.0):
		hue -= 1.0
	var border_color = Color.from_hsv(hue, 1, 1)
	
	if(highlighted):
		var hover_mul = 0.75
		var pressed_mul = 0.25
		bg_color_normal = border_color
		bg_color_hover = Color(border_color.r * hover_mul, border_color.g * hover_mul, border_color.b * hover_mul, 1.0)
		bg_color_pressed = Color(border_color.r * pressed_mul, border_color.g * pressed_mul, border_color.b * pressed_mul, 1.0)
		character_color = Color(0,0,0)
	else:
		bg_color_normal = Color(0,0,0)
		bg_color_hover = Color(0,0,0)
		bg_color_pressed = Color(0,0,0)
		character_color = border_color

	outline_style_normal.bg_color = bg_color_normal
	outline_style_hover.bg_color = bg_color_hover
	outline_style_pressed.bg_color = bg_color_pressed
	outline_style_normal.border_color = border_color
	outline_style_hover.border_color = border_color
	outline_style_pressed.border_color = border_color

	# Force update theme style
	add_theme_stylebox_override("normal", outline_style_normal)
	add_theme_stylebox_override("hover", outline_style_hover)
	add_theme_stylebox_override("pressed", outline_style_pressed)
	
	var lbl = get_node_or_null("HW_KeyText") as Label
	if(lbl != null):
		lbl.set("theme_override_colors/font_color", character_color)
