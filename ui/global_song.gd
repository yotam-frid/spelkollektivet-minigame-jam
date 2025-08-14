extends Node

signal beat

var bpm = 125
var beat_timer: Timer

var node_tweens: Dictionary[Node, Array]
var animate_time: float = 0.12

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beat_timer = Timer.new()
	beat_timer.timeout.connect(_on_beat_timer_timeout)
	beat_timer.ignore_time_scale = true
	add_child(beat_timer)
	
	start()

func change_bpm(num: float):
	beat_timer.stop()
	bpm = num
	start()

func start():
	beat_timer.wait_time = 60.0 / bpm
	beat_timer.start()

func animate_on_beat(target: Node, property: NodePath, animate_value: Variant, relative: bool = false):
	# Create a definitions array for this node if it was not registered
	if !node_tweens.has(target):
		node_tweens[target] = []
		
	# Create definition
	var target_tweens = node_tweens[target]
	var definition = {}
	definition["property"] = property
	definition["animate_value"] = animate_value
	definition["relative"] = relative
	target_tweens.append(definition)
	
	# Connect cleanup
	var clear_callable = _on_animated_node_exit_tree.bind(target)
	target.tree_exiting.connect(clear_callable)
	
func clear_animations(target: Node):
	if node_tweens.has(target):
		# Erase all animation definitions for this node
		node_tweens.erase(target)
	
func _on_animated_node_exit_tree(node: Node):
	clear_animations(node)

func _on_beat_timer_timeout() -> void:
	_animate_registered_nodes()
	beat.emit()

func _animate_registered_nodes():
	for node: Node in node_tweens.keys():
		var definitions = node_tweens[node]
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true)
		
		for definition in definitions:
			var property = definition["property"]
			var property_string = str(property)
			var animate_value = definition["animate_value"]
			var revert_value = node.get(property_string)
			
			if definition["relative"]:
				animate_value += revert_value
			node.set(property_string, animate_value)
			tween.tween_property(node, property, revert_value, animate_time)
