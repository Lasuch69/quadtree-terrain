class_name QuadTree

const MAX_DEPTH = 4

static func create_tree(target: Vector2, rect: Rect2) -> Array[QuadNode]:
	var nodes: Array[QuadNode]
	var node := QuadNode.new(rect, 0)
	_step(target, node, nodes)
	
	return nodes

static func _step(target: Vector2, node: QuadNode, nodes: Array[QuadNode]) -> void:
	if node.depth >= MAX_DEPTH:
		return
	
	var distance: float = target.distance_to(node.rect.get_center())
	var exponent: float = (node.depth / 5.0) + 1.0
	var cost: float = pow(distance, exponent)
	
	if cost > 150.0:
		return
	
	var new_nodes := _subdivide(node)
	nodes.append_array(new_nodes)
	nodes.erase(node)
	
	for new_node: QuadNode in new_nodes:
		_step(target, new_node, nodes)

static func _subdivide(node: QuadNode) -> Array[QuadNode]:
	var new_nodes: Array[QuadNode]
	
	for i: int in 4:
		var rect = _get_node_rect(node.rect, i)
		var depth = node.depth + 1
		
		var new_node := QuadNode.new(rect, depth)
		new_nodes.append(new_node)
	
	return new_nodes

static func _get_node_rect(rect: Rect2, direction: Corner) -> Rect2:
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
