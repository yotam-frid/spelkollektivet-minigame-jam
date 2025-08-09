extends Control
class_name GrowShrinkUI

var target_node: CanvasItem

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var child = get_child(0)
	target_node = child if child is AnimatedSprite2D else self

func animate_show():
	target_node.scale = Vector2.ZERO
	visible = true
	
	await get_tree().process_frame
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target_node, "scale", Vector2.ONE, 0.3)
	
func animate_hide():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target_node, "scale", Vector2.ZERO, 0.3)
	tween.tween_callback(func(): visible = false)
