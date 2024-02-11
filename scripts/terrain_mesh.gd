class_name TerrainMesh

static func create_center_tile(tile_size: float, tile_resolution) -> PackedVector3Array:
	var vertices = PackedVector3Array()
	
	for y: int in tile_resolution:
		for x: int in tile_resolution:
			var quad := _get_center_quad()
			
			var coords = Vector2i(x, y)
			_transform(quad, coords, tile_size, tile_resolution)
			
			vertices.append_array(quad)
	
	return vertices

static func create_side_tile(tile_size: float, tile_resolution) -> PackedVector3Array:
	var vertices = PackedVector3Array()
	
	for y: int in tile_resolution:
		for x: int in tile_resolution:
			var quad := _get_center_quad()
			
			if y == 0:
				quad = _get_side_quad()
			
			var coords = Vector2i(x, y)
			_transform(quad, coords, tile_size, tile_resolution)
			
			vertices.append_array(quad)
	
	return vertices

static func create_corner_tile(tile_size: float, tile_resolution: int) -> PackedVector3Array:
	var vertices = PackedVector3Array()
	
	for y: int in tile_resolution:
		for x: int in tile_resolution:
			var quad := _get_center_quad()
			
			if x == 0 and y == 0:
				quad = _get_corner_quad()
			elif x == 0:
				quad = _get_side_quad()
				_rotate(quad, PI / 2)
			elif y == 0:
				quad = _get_side_quad()
			
			var coords = Vector2i(x, y)
			_transform(quad, coords, tile_size, tile_resolution)
			
			vertices.append_array(quad)
	
	return vertices

static func _transform(vertices: PackedVector3Array, quad_coords: Vector2i, tile_size: float, tile_resolution: int) -> void:
	for idx: int in vertices.size():
		var v := vertices[idx]
		
		v.x += quad_coords.x
		v.z += quad_coords.y
		
		v /= tile_resolution
		
		v *= tile_size
		v -= Vector3(tile_size, 0.0, tile_size) / 2
		
		vertices[idx] = v

static func _rotate(vertices: PackedVector3Array, angle: float) -> void:
	for idx: int in vertices.size():
		var v = vertices[idx]
		var half_quad := Vector3(0.5, 0.5, 0.5)
		
		# center
		v -= half_quad
		
		# rotate
		v = v.rotated(Vector3.UP, angle)
		
		# move back to original position
		v += half_quad
		
		vertices[idx] = v

static func _get_center_quad() -> PackedVector3Array:
	var v0 = _vec3(0, 0) # 0, 0
	var v1 = _vec3(1, 0) # 1, 0
	var v2 = _vec3(0, 1) # 0, 1
	
	var v3 = _vec3(1, 0) # 1, 0
	var v4 = _vec3(1, 1) # 1, 1
	var v5 = _vec3(0, 1) # 0, 1
	
	return [v0, v1, v2, v3, v4, v5]

static func _get_side_quad() -> PackedVector3Array:
	var v0 = _vec3(0, 0) # 0, 0
	var v1 = _vec3(0.5, 0.0) # 0.5, 0
	var v2 = _vec3(0, 1) # 0, 1
	
	var v3 = _vec3(0.5, 0) # 0.5, 0
	var v4 = _vec3(1, 0) # 1, 0
	var v5 = _vec3(1, 1) # 1, 1
	
	var v6 = _vec3(0.5, 0) # 0.5, 0
	var v7 = _vec3(1, 1) # 1, 1
	var v8 = _vec3(0, 1) # 0, 1
	
	return [v0, v1, v2, v3, v4, v5, v6, v7, v8]

static func _get_corner_quad() -> PackedVector3Array:
	var v0 = _vec3(0, 0)
	var v1 = _vec3(0.5, 0)
	var v2 = _vec3(0, 0.5)
	
	var v3 = _vec3(0.5, 0)
	var v4 = _vec3(1, 0)
	var v5 = _vec3(1, 1)
	
	var v6 = _vec3(0, 0.5)
	var v7 = _vec3(1, 1)
	var v8 = _vec3(0, 1)
	
	var v9 = _vec3(0, 0.5)
	var v10 = _vec3(0.5, 0)
	var v11 = _vec3(1, 1)
	
	return [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11]

static func _vec3(x: float, y: float) -> Vector3:
	return Vector3(x, 0.0, y)
