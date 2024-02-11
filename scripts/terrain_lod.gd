class_name TerrainLOD

static func get_lods(camera: Vector2i, map: Rect2i) -> Array[Vector3i]:
	var tiles: Array[Vector3i] = []
	
	for y: int in map.size.y:
		for x: int in map.size.x:
			var coords := Vector2i(x, y) + map.position
			var lod: int = _calculate_lod(coords, camera)
			
			var left: int = _calculate_lod(coords + Vector2i.LEFT, camera) - lod
			var right: int = _calculate_lod(coords + Vector2i.RIGHT, camera) - lod
			var up: int = _calculate_lod(coords + Vector2i.UP, camera) - lod
			var down: int = _calculate_lod(coords + Vector2i.DOWN, camera) - lod
			
			var dir_x: int = clampi(left - right, -1, 1)
			var dir_y: int = clampi(up - down, -1, 1)
			
			tiles.append(Vector3i(dir_x, dir_y, lod))
	
	return tiles

static func _calculate_lod(coords: Vector2i, camera: Vector2i) -> int:
	var distance: float = (camera - coords).length()
	return floori(distance / 2.0)
