extends Line2D

@export var dash_width: float = 20.0
@export var gap_width: float = 10.0

func _ready():
	create_dashed_line()

func create_dashed_line():
	# Clear any existing child lines
	for child in get_children():
		if child is Line2D:
			child.queue_free()
	
	# Need exactly 2 points
	if points.size() != 2:
		return
	
	var start_point = points[0]
	var end_point = points[1]
	var total_distance = start_point.distance_to(end_point)
	var direction = (end_point - start_point).normalized()
	
	var current_distance = 0.0
	var is_dash = true
	
	while current_distance < total_distance:
		if is_dash:
			# Create dash
			var dash_line = Line2D.new()
			add_child(dash_line)
			
			# Copy properties from parent
			dash_line.width = width
			dash_line.default_color = default_color
			dash_line.texture = texture
			dash_line.texture_mode = texture_mode
			dash_line.joint_mode = joint_mode
			dash_line.begin_cap_mode = begin_cap_mode
			dash_line.end_cap_mode = end_cap_mode
			dash_line.sharp_limit = sharp_limit
			dash_line.round_precision = round_precision
			dash_line.antialiased = antialiased
			
			var dash_start = start_point + direction * current_distance
			var dash_end_distance = min(current_distance + dash_width, total_distance)
			var dash_end = start_point + direction * dash_end_distance
			
			dash_line.add_point(dash_start)
			dash_line.add_point(dash_end)
			
			current_distance += dash_width
		else:
			# Skip gap
			current_distance += gap_width
		
		is_dash = !is_dash
	
	# Clear the original points
	clear_points()

func update_dash():
	create_dashed_line()
