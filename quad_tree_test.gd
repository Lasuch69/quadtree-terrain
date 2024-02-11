extends Node2D

const GRID_SIZE = 4
const TILE_SIZE = Vector2(128, 128)

func _ready() -> void:
	for i: int in 4:
		var angle := (PI / 2) * i
		var point: Vector2 = Vector2.from_angle(angle)
		print(point)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var point = get_local_mouse_position()
	
	var grid: Array[Rect2]
	var tree: Array[QuadNode]
	
	for y: int in GRID_SIZE:
		for x: int in GRID_SIZE:
			var tile_position = Vector2(x, y) * TILE_SIZE
			var tile_rect = Rect2(tile_position, TILE_SIZE)
			
			grid.append(tile_rect)
			
			var color = Color.GREEN
			draw_rect(tile_rect, color, false)
	
	for tile: Rect2 in grid:
		var nodes = QuadTree.create_tree(point, tile)
		
		if nodes.is_empty():
			var node = QuadNode.new(tile, -1)
			tree.push_front(node)
		
		tree.append_array(nodes)
	
	for node: QuadNode in tree:
		var colors = [Color.GREEN, Color.YELLOW_GREEN, Color.YELLOW, Color.ORANGE, Color.ORANGE_RED, Color.RED]
		var color = colors[node.depth + 1]
		
		var neighbour_nodes: Array[QuadNode] = tree.filter(is_neighbour.bind(node))
		
		for neighbour_node: QuadNode in neighbour_nodes:
			if node.depth <= neighbour_node.depth:
				continue
			
			draw_circle(neighbour_node.rect.get_center(), 3.0, color)
		
		draw_rect(node.rect, color, false)
	
	#draw_rect(target, Color.RED, false)

func is_neighbour(other_node: QuadNode, node: QuadNode) -> bool:
	var is_neighbour := false
	
	if other_node == node:
		return false
	
	for i: int in 4:
		var angle := (PI / 2) * i
		var point: Vector2 = node.rect.get_center() + Vector2.from_angle(angle) * node.rect.size.x
		
		if other_node.rect.has_point(point):
			is_neighbour = true
			break
	
	return is_neighbour
