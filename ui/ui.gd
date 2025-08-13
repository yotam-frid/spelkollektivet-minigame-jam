extends Control
class_name UI

var minigame_won = false

@export var minigame_viewport_container: SubViewportContainer
@export var minigame_viewport: SubViewport
@export var ingame_ui: IngameUI

@onready var main_scene_foreground: MainSceneForegroundUI = $MainSceneForeground
@onready var intro_controls_reset_pos = $IntroControls.position
@onready var lives: LivesUI = $Lives
@onready var lives_reset_pos = lives.position

signal minigame_zoomed_in
signal minigame_zoomed_out
signal ready_for_next_minigame

var current_minigame: Minigame = null
var minigame_zoomed_out_scale = Vector2.ONE / 3.5
var minigame_zoom_duration = 0.5

func _ready() -> void:
	_hide_controls(false)
	_hide_text(false)
	lives.init_lives(4)
	_center_pivot(minigame_viewport_container)

func show_minigame_intro(minigame: Minigame):	
	_hide_lives()
	_show_controls(minigame)
	main_scene_foreground.open()
	await main_scene_foreground.opened
	await _create_ui_timer(1.0)
	
func start_game(minigame: Minigame):
	_hide_controls(true)
	await _create_ui_timer(0.5)
	show_minigame_viewport(minigame)
	_show_text(minigame.title)
	zoom_in_on_game(minigame)
	await _create_ui_timer(1.5)
	_hide_text(true)
	
func finish_game(minigame: Minigame, won: bool):
	set_won(won)
	_show_lives()
	await hide_minigame_viewport()
	clear_viewport()
	# Emits to the manager we can safely unload the minigame
	minigame_zoomed_out.emit()
	
	await inbetween()
	
	ready_for_next_minigame.emit()
	
func show_minigame_viewport(minigame: Minigame):
	# Load minigame into viewport
	minigame_viewport.add_child(minigame)
	if minigame.viewport_texture_filter:
		minigame_viewport_container.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		minigame_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR
	else:
		minigame_viewport_container.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		minigame_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	minigame_viewport_container.stretch_shrink = minigame.viewport_zoom
	minigame.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Open curtains, wait for the TV zoom effect
	minigame_viewport_container.show()
	minigame_viewport_container.scale = minigame_zoomed_out_scale # This should fit in the viewport
	
func zoom_in_on_game(minigame: Minigame):
	# Re-enable minigame process
	minigame.process_mode = Node.PROCESS_MODE_INHERIT
	# Show ingame UI and zoom in
	minigame_viewport_container.visible = true
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(minigame_viewport_container, "scale", Vector2.ONE, minigame_zoom_duration)
	tween.tween_callback(func():
		minigame_zoomed_in.emit()
	)
	
	main_scene_foreground.zoom()
	
	
func hide_minigame_viewport():
	hide_ingame_ui()
	main_scene_foreground.close()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(minigame_viewport_container, "scale", minigame_zoomed_out_scale, minigame_zoom_duration / 2.0)
	
	await main_scene_foreground.closed
	
	minigame_viewport_container.hide()
	
func set_won(won: bool):
	minigame_won = won
	
## Downtime between games
func inbetween():
	main_scene_foreground.show_post_game(minigame_won)
	
	_show_lives()
	if not minigame_won:
		lives.lose_life()
		
	await _create_ui_timer(1.0)
		
	main_scene_foreground.reset()
	await _create_ui_timer(1.0)
	
	
func clear_viewport():
	var nodes = minigame_viewport.get_children()
	for n in nodes:
		minigame_viewport.remove_child(n)
	
	
func _create_ui_timer(duration: float):
	await get_tree().create_timer(duration, true, false, true).timeout

func _show_controls(minigame: Minigame):
	$IntroControls.position = intro_controls_reset_pos
	$IntroControls.visible = true
	# Mouse
	var show_mouse = minigame.mouse != 0
	var left_click = minigame.mouse & 2
	var right_click = minigame.mouse & 4
	
	if show_mouse:
		if left_click and right_click:
			%IntroMouseSprite.play("both")
		elif left_click:
			%IntroMouseSprite.play("left_click")
		elif right_click:
			%IntroMouseSprite.play("right_click")
		else:
			%IntroMouseSprite.play("default")
		
		%IntroMouse.animate_show()
		
	# Keyboard
	var kbd_directionals = minigame.keyboard & 1
	var kbd_spacebar = minigame.keyboard & 2
	var kbd_full = minigame.keyboard & 4
	
	if kbd_directionals and kbd_spacebar:
		%IntroArrowsAndSpace.animate_show()
	else:
		if kbd_directionals:
			%IntroDirectionals.animate_show()
		if kbd_spacebar:
			%IntroSpacebar.animate_show()
		if kbd_full:
			%IntroFullKeyboard.animate_show()
		
	# Reset sprite animations
	for n: Control in %IntroControls.get_children():
		for n_child in n.get_children():
			if n_child is AnimatedSprite2D:
				n_child.set_frame_and_progress(0, 0.0)
			
func _hide_controls(animate: bool):
	for n: GrowShrinkUI in %IntroControls.get_children():
		if animate:
			n.animate_hide()
		else:
			n.visible = false
		
	await _create_ui_timer(0.5)
	%IntroControls.visible = false
	
func _hide_text(animate: bool):
	if animate:
		%IntroText.animate_hide()
	else:
		%IntroText.visible = false
		

func _show_text(text: String):
	text = text if text.ends_with("!") else text + "!"
	%IntroTextLabel.text = text
	%IntroText.animate_show()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($IntroControls, "position", intro_controls_reset_pos + Vector2.DOWN * 80, 0.3)

func show_ingame_ui(minigame: Minigame):
	ingame_ui.show_for_minigame(minigame)
	
func hide_ingame_ui():
	ingame_ui.hide()

func _center_pivot(control: Control):
	control.pivot_offset = control.size / 2

func _show_lives():
	var tween = create_tween()
	tween.tween_property(lives, "position", lives_reset_pos, 0.3)

func _hide_lives():
	var tween = create_tween()
	tween.tween_property(lives, "position", lives_reset_pos + Vector2.DOWN * 400, 0.3)
