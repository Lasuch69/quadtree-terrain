class_name QuadTree

const MAX_DEPTH = 5

static func create_tree(target: Rect2, rect: Rect2) -> Array[Rect2]:
	var rects: Array[Rect2]
	_step(target, rect, rects)
	
	return rects

static func _step(target: Rect2, rect: Rect2, rects: Array[Rect2], depth: int = 0) -> void:
	if depth >= MAX_DEPTH or !rect.intersects(target):
		return
	
	var new_rects := _subdivide(rect)
	rects.append_array(new_rects)
	
	for new_rect: Rect2 in new_rects:
		var distance: float = target.get_center().distance_to(new_rect.get_center())
		var exponent: float = (depth / 4.0) + 1.0
		var cost: float = pow(distance, exponent)
		
		if cost > 100.0:
			continue
		
		_step(target, new_rect, rects, depth + 1)

static func _subdivide(rect: Rect2) -> Array[Rect2]:
	var rects: Array[Rect2]
	
	for i: int in 4:
		rects.append(_get_child_rect(rect, i))
	
	return rects

static func _get_child_corner(rect: Rect2, point: Vector2) -> Corner:
	var center := rect.get_center()
	
	if point.y < center.y:
		if point.x < center.x:
			return CORNER_TOP_LEFT
		else:
			return CORNER_TOP_RIGHT
	else:
		if point.x < center.x:
			return CORNER_BOTTOM_LEFT
		else:
			return CORNER_BOTTOM_RIGHT

static func _get_child_rect(rect: Rect2, direction: Corner) -> Rect2:
	var new_size := rect.size / 2.0
	var new_position := rect.position
	
	match direction:
		CORNER_TOP_RIGHT:
			new_position += Vector2(new_size.x, 0.0)
		CORNER_BOTTOM_LEFT:
			new_position += Vector2(0.0, new_size.y)
		CORNER_BOTTOM_RIGHT:
			new_position += new_size
	
	return Rect2(new_position, new_size)
