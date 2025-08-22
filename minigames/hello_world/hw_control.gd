extends Control

var screen_width = 960
var screen_height = 720
var code_x = 0.5 * screen_width
var code_y = 0.225 * screen_height
var code_width = 0.1 * screen_width
var code_height = 0.1 * screen_height
var font_size = 64
var code_strings = ["C=C--",
					"KILL CHILD",
					"THROW TABLE",
					"DEL SYSTEM32",
					"WHILE[TRUE]",
					"WHILE[I>0]",
					"ARRAY[-1]",
					"VAR X=1/0",
					"FOR I=0;I<1;I--"]
var win_strings = ["error at line -1",
					"blood sacrifice\n accepted ",
					" (/°0°)/( |___|",
					"cannot be completed\nfolder is open in\nanother program",
					":(",
					"task failed succesfully",
					"index out of bounds",
					"error: divide by zero",
					"stack overflow"]
var code_string: String = ""
var code_color = Color(1.0, 1.0, 1.0, 1.0)
var code_preview_color = Color(0.5, 0.5, 0.5, 1.0)
var key_object = preload("res://minigames/hello_world/hw_key.tscn")
var key_dx = 64
var key_dy = 64
var key_width = 64;
var key_height = 64;
var key_space_width = 6 * key_width;
var key_space_height = key_height;
var keyboard_x = 0.5 * screen_width
var keyboard_y = 0.7 * screen_height
var keyboard_width = 13 * key_dx
var keyboard_height = 6 * key_dy
var monitor_x = 0.5 * screen_width
var monitor_y = screen_height - (keyboard_y + (0.5 * keyboard_height)) # keyboard_y - (0.5 * (keyboard_height + monitor_height))
var monitor_width = 13 * key_dx
var monitor_height = (keyboard_y - (0.5 * keyboard_height)) - monitor_y
var monitor_outline = key_dx
var hue = 0
var hue_speed = 0.2
var hue_speed_won = -1
var background_outline_color = Color.WHITE
var won = false
var win_screen_color = Color(0.117647, 0.564706, 1, 2) * 0.5
var code_preview_string = ""
var win_string = ""

func _ready():
	var difficulty = CurrentGame.instance.difficulty
	var code_preview_index = randi() % code_strings.size()
	code_preview_string = code_strings[code_preview_index] # code_strings[code_strings.size() - 1]
	win_string = win_strings[code_preview_index]
	play_sound(preload("res://minigames/hello_world/HW_MouseClickSFX.mp3"), 0, 1, 0, false)
	
	set_text("HW_CodePreviewLabel", code_x, code_y, code_preview_string, code_preview_color)
	create_keyboard()
	CurrentGame.instance.duration = 4 + (0.5 * code_preview_string.length())

func _process(delta):
	hue += delta * hue_speed # speed of hue change
	if (hue < 0.0):
		hue += 1.0
	elif (hue > 1.0):
		hue -= 1.0
	background_outline_color = Color.from_hsv(hue, 1, 1)
	queue_redraw()
	var str = code_string + "_"
	var color = background_outline_color
	if (won):
		str = win_string
		color = Color.WHITE * 0.5 * background_outline_color
	set_text("HW_CodeLabel", code_x, code_y, str, color)
#
#func _draw():
	#var thickness = 3.0
	#var x = 0
	#var y = 0
	#var width = 0
	#var height = 0
	#
	##Background
	#draw_rect(Rect2(-1, -1, screen_width + 2, screen_height + 2), Color.BLACK)
	##draw_rect(Rect2(-1, -1, screen_width + 2, screen_height + 2), background_outline_color)
	##draw_rect(Rect2(thickness, thickness, screen_width - (2 * thickness), screen_height - (2 * thickness)), Color.BLACK)
	#
	##Monitor
	#x = monitor_x - (0.5 * monitor_width)
	#y = monitor_y
	#width = monitor_width
	#height = monitor_height
#
	#draw_rect(Rect2(x - thickness, y - thickness, width + (2 * thickness), height + (2 * thickness)), background_outline_color)
	#draw_rect(Rect2(x, y, width, height), Color.BLACK)
	#
	##Monitor screen
	#x = monitor_x - (0.5 * (monitor_width - monitor_outline))
	#y = monitor_y + (0.5 * monitor_outline)
	#width = monitor_width - monitor_outline
	#height = monitor_height - monitor_outline
	#
	#var monitor_color = Color.BLACK
	#if(won):
		#monitor_color = win_screen_color
		#
	#draw_rect(Rect2(x - thickness, y - thickness, width + (2 * thickness), height + (2 * thickness)), background_outline_color)
	#draw_rect(Rect2(x, y, width, height), monitor_color)
	#
	##Keyboard
	#x = keyboard_x - (0.5 * keyboard_width)
	#y = keyboard_y - (0.5 * keyboard_height)
	#width = keyboard_width
	#height = keyboard_height
	#
	#draw_rect(Rect2(x - thickness, y - thickness, width + (2 * thickness), height + (2 * thickness)), background_outline_color)
	#draw_rect(Rect2(x, y, width, height), Color.BLACK)

func play_sound(sound, volume, pitch, offset, loop):
	var player := AudioStreamPlayer2D.new()
	player.stream = sound
	player.volume_db = volume
	player.pitch_scale = pitch
	get_tree().current_scene.add_child(player)
	player.play()
	var sound_length = player.stream.get_length()
	await get_tree().create_timer(sound_length).timeout
	if player: # make sure it still exists
		player.queue_free()

func set_text(label, x, y, text, color):
	var lbl = get_node_or_null(label) as Label
	var lbl_preview = get_node_or_null("HW_CodePreviewLabel")
	if (lbl != null):
		lbl.text = text
		lbl.set("theme_override_colors/font_color", color)
		lbl.add_theme_font_size_override("font_size", font_size)
		lbl.add_theme_constant_override("line_spacing", -16)
		lbl.set_position(Vector2(x, y) - (0.5 * lbl_preview.size))
		if (text == ":("):
			lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		if (won):
			pass
			#lbl.add_theme_constant_override("outline_size",2)

func set_character(object, label, text, color):
	var button = object as Button
	var lbl = button.get_node_or_null(label) as Label
	if (lbl != null):
		lbl.text = text
		lbl.set("theme_override_colors/font_color", color)
		lbl.set_position(lbl.position - (0.5 * lbl.size) + (0.5 * object.size))
		lbl.add_theme_constant_override("outline_size", 2)

func key_pressed(character):
	if (!won):
		if (code_preview_string[code_string.length()] == character):
			var volume = 0
			var pitch = (0.65 + 0.7 * (float(code_string.length()) / code_preview_string.length())) # + randf_range(-0.05, 0.05)
			var offset = 0
			play_sound(preload("res://minigames/hello_world/HW_MouseClickSFX.mp3"), volume, pitch, offset, false)
			play_sound(preload("res://minigames/hello_world/HW_KeyClickSFX.wav"), volume, pitch, offset, false)
			self.code_string += character
		else:
			var pitch = randf_range(0.9, 1.1)
			var offset = 0
			play_sound(preload("res://minigames/hello_world/HW_WrongClickSFX.mp3"), -6, pitch, offset, false)
		if (code_preview_string == code_string):
			var pitch = 1
			var offset = 0
			play_sound(preload("res://minigames/hello_world/HW_CrashSFX.wav"), 4.0, pitch, offset, false)
			play_sound(preload("res://minigames/hello_world/HW_GruntBirthdaySFX.mp3"), 0.0, pitch, offset, false)
			var victory_text = "You crashed the computer and face dad's wrath.\nCongrats!"
			won = true
			code_preview_string = win_string
			code_string = win_string
			set_text("HW_CodeLabel", code_x, code_y, win_string, code_color)
			set_text("HW_CodePreviewLabel", code_x, code_y, win_string, code_color)
			hue_speed = hue_speed_won
			CurrentGame.instance.win_and_finish()
		highlight_key()

func create_key(character, key_position):
	var obj = key_object.instantiate() as Button
	add_child(obj)
	obj.add_to_group("keyboard_keys")
	obj.set_meta("character", character)
	obj.pressed.connect(key_pressed.bind(character))
	var label = "HW_KeyText"
	var color = Color(1.0, 1.0, 1.0)
	if (character == " "):
		obj.set_size(Vector2(key_space_width, key_space_height))
		obj.set_position(Vector2(key_position[0] - (0.5 * (key_space_width - key_width)), key_position[1]))
		obj.collision_size_normal = Vector2(key_space_width, key_space_height)
		obj.collision_size_highlighted = obj.collision_size_normal + Vector2(16, 16)
		set_character(obj, label, character, color)
	elif (character == "~"):
		obj.set_size(Vector2(2 * key_width, key_height))
		obj.set_position(Vector2(key_position[0], key_position[1]))
		obj.collision_size_normal = Vector2(2 * key_width, key_space_height)
		obj.collision_size_highlighted = obj.collision_size_normal + Vector2(16, 16)
		set_character(obj, label, "shift", color)
	else:
		obj.set_size(Vector2(key_width, key_height))
		obj.set_position(key_position)
		set_character(obj, label, character, color)
	obj.collision_position = obj.position
	obj.hue = fposmod((obj.position.x + (0.25 * obj.position.y)) * obj.hue_speed / keyboard_width, 1.0)
	#obj.hue = fposmod(((obj.position.x - (keyboard_x + (0.5*keyboard_width))) / (keyboard_width + key_dx)), 1.0)

func create_keyboard():
	var keyboard_characters = ["1234567890-=", "QWERTYUIOP[]", "ASDFGHJKL;'↩", "~_ZXCVBNM<>/", " "]
	var row_count = keyboard_characters.size()
	for row in range(row_count):
		var row_string: String = keyboard_characters[row]
		var string_length = row_string.length()
		for c in range(string_length):
			var character = row_string[c]
			if (character != "_"):
				create_key(character, Vector2(keyboard_x + (key_dx * (c - (0.5 * string_length))), keyboard_y + (key_dy * (row - (0.5 * row_count)))))
	highlight_key()

func highlight_key():
	var character = ""
	if (!won):
		character = code_preview_string[code_string.length()]

	for node in get_tree().get_nodes_in_group("keyboard_keys"):
		var button = node as Button
		if (character == button.get_meta("character")):
			if (button.highlighted != true):
				button.highlighted = true
				button.move_to_front()
				button.set_size(button.collision_size_highlighted)
				button.set_position(button.collision_position - Vector2(12, 12))
				var lbl = button.get_node_or_null("HW_KeyText") as Label
				lbl.set_position(lbl.position + Vector2(12, 12))
		elif (button.highlighted == true):
			button.highlighted = false
			button.set_size(button.collision_size_normal)
			button.set_position(button.collision_position)
			var lbl = button.get_node_or_null("HW_KeyText") as Label
			lbl.set_position(lbl.position - Vector2(12, 12))
		if (won):
			button.hue_speed = hue_speed_won
