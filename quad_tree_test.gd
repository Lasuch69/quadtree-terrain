extends Node2D

const GRID_SIZE = 4
const TILE_SIZE = Vector2(128, 128)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var point = get_local_mouse_position()
	var size = Vector2(150, 150)
	var target = Rect2(point - size / 2, size)
	
	var grid: Array[Rect2]
	
	for y: int in GRID_SIZE:
		for x: int in GRID_SIZE:
			var tile_position = Vector2(x, y) * TILE_SIZE
			var tile_rect = Rect2(tile_position, TILE_SIZE)
			
			grid.append(tile_rect)
			draw_rect(tile_rect, Color.GREEN_YELLOW, false)
	
	for tile: Rect2 in grid:
		var tree = QuadTree.create_tree(target, tile)
		
		for quad: Rect2 in tree:
			draw_rect(quad, Color.BLUE, false)
	
	draw_rect(target, Color.RED, false)
