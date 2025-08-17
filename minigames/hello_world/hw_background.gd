extends Node2D

var screen_width = 960
var screen_height = 720
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
var monitor_y = screen_height - (keyboard_y + (0.5 * keyboard_height)) #keyboard_y - (0.5 * (keyboard_height + monitor_height))
var monitor_width = 13 * key_dx
var monitor_height = (keyboard_y - (0.5 * keyboard_height)) - monitor_y
var monitor_outline = key_dx
var hue = 0
var hue_speed = 0.2
var hue_speed_won = -1
var background_outline_color = Color.WHITE
var win_screen_color = Color(0.117647, 0.564706, 1, 2) * 0.5

func _process(delta):
	hue += delta * hue_speed  # speed of hue change
	if(hue < 0.0):
		hue += 1.0
	elif(hue > 1.0):
		hue -= 1.0
	background_outline_color = Color.from_hsv(hue, 1, 1)
	queue_redraw()

func _draw():
	var monitor_color = Color.BLACK
	var node_control = get_parent()
	if(node_control != null && node_control.won):
		hue_speed = hue_speed_won
		monitor_color = win_screen_color
	
	var thickness = 3.0
	var x = 0
	var y = 0
	var width = 0
	var height = 0
	
	#Background
	draw_rect(Rect2(-1, -1, screen_width + 2, screen_height + 2), Color.BLACK)
	#draw_rect(Rect2(-1, -1, screen_width + 2, screen_height + 2), background_outline_color)
	#draw_rect(Rect2(thickness, thickness, screen_width - (2 * thickness), screen_height - (2 * thickness)), Color.BLACK)
	
	#Monitor
	x = monitor_x - (0.5 * monitor_width)
	y = monitor_y
	width = monitor_width
	height = monitor_height

	draw_rect(Rect2(x - thickness, y - thickness, width + (2 * thickness), height + (2 * thickness)), background_outline_color)
	draw_rect(Rect2(x, y, width, height), Color.BLACK)
	
	#Monitor screen
	x = monitor_x - (0.5 * (monitor_width - monitor_outline))
	y = monitor_y + (0.5 * monitor_outline)
	width = monitor_width - monitor_outline
	height = monitor_height - monitor_outline
	
	draw_rect(Rect2(x - thickness, y - thickness, width + (2 * thickness), height + (2 * thickness)), background_outline_color)
	draw_rect(Rect2(x, y, width, height), monitor_color)
	
	#Keyboard
	x = keyboard_x - (0.5 * keyboard_width)
	y = keyboard_y - (0.5 * keyboard_height)
	width = keyboard_width
	height = keyboard_height
	
	draw_rect(Rect2(x - thickness, y - thickness, width + (2 * thickness), height + (2 * thickness)), background_outline_color)
	draw_rect(Rect2(x, y, width, height), Color.BLACK)
