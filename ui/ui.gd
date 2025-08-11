extends Control
class_name UI

var minigame_won = false

@export var minigame_viewport_container: SubViewportContainer
@export var minigame_viewport: SubViewport
@export var ingame_ui: IngameUI
var current_minigame: Minigame = null

func _ready() -> void:
	_hide_controls(false)
	_hide_text(false)
	_center_pivot(minigame_viewport_container)

func show_minigame_intro(minigame: Minigame):
	_show_controls(minigame)
	await _create_ui_timer(1.5)
	_show_text(minigame.title)
	await _create_ui_timer(1.0)
	
func hide_minigame_intro():
	_hide_controls(true)
	await get_tree().create_timer(0.5).timeout
	_hide_text(true)
	
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
	
	# Show the viewport and ingame UI
	minigame_viewport_container.scale = Vector2.ZERO
	minigame_viewport_container.visible = true
	show_ingame_ui(minigame)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(minigame_viewport_container, "scale", Vector2.ONE, 0.5)
	
func hide_minigame_viewport():
	hide_ingame_ui()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(minigame_viewport_container, "scale", Vector2.ZERO, 0.2)
	await tween.finished
	
	minigame_viewport_container.hide()
	
func set_won(won: bool):
	minigame_won = won
	
## Downtime between games
func inbetween():
	if minigame_won:
		%WinLabel.visible = true
	else:
		%LoseLabel.visible = true
		
	await _create_ui_timer(3.0)
	%WinLabel.visible = false
	%LoseLabel.visible = false	
	
func clear_viewport():
	var nodes = minigame_viewport.get_children()
	for n in nodes:
		minigame_viewport.remove_child(n)
	
	
func _create_ui_timer(duration: float):
	await get_tree().create_timer(duration, true, false, true).timeout

func _show_controls(minigame: Minigame):
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

func show_ingame_ui(minigame: Minigame):
	ingame_ui.show_for_minigame(minigame)
	
func hide_ingame_ui():
	ingame_ui.hide()

func _center_pivot(control: Control):
	control.pivot_offset = control.size / 2
