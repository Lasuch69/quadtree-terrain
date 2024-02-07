@tool
extends MeshInstance3D

const TILE_RESOLUTION: int = 16
const TILE_SIZE: float = 2.0

const SIZE := Vector2i(3, 3)

@onready var _camera: Camera3D = EditorInterface.get_editor_viewport_3d().get_camera_3d()
var _snapped_pos: Vector2

func _ready() -> void:
	var vertices = PackedVector3Array()
	
	for y: int in TILE_RESOLUTION:
		for x: int in TILE_RESOLUTION:
			if x == 0 and y == 0:
				var vertex0 = _get_vertex(x, y)
				var vertex1 = _get_vertex(x + 0.5, y)
				var vertex2 = _get_vertex(x, y + 0.5)
				
				var vertex3 = _get_vertex(x + 0.5, y)
				var vertex4 = _get_vertex(x + 1, y)
				var vertex5 = _get_vertex(x + 1, y + 1)
				
				var vertex6 = _get_vertex(x, y + 0.5)
				var vertex7 = _get_vertex(x + 1, y + 1)
				var vertex8 = _get_vertex(x, y + 1)
				
				var vertex9 = _get_vertex(x, y + 0.5)
				var vertex10 = _get_vertex(x + 0.5, y)
				var vertex11 = _get_vertex(x + 1, y + 1)
				
				vertices.push_back(vertex0)
				vertices.push_back(vertex1)
				vertices.push_back(vertex2)
				
				vertices.push_back(vertex3)
				vertices.push_back(vertex4)
				vertices.push_back(vertex5)
				
				vertices.push_back(vertex6)
				vertices.push_back(vertex7)
				vertices.push_back(vertex8)
				
				vertices.push_back(vertex9)
				vertices.push_back(vertex10)
				vertices.push_back(vertex11)
				
				continue
			
			if x == 0:
				var vertex0 = _get_vertex(x, y + 0.5)
				var vertex1 = _get_vertex(x, y)
				var vertex2 = _get_vertex(x + 1, y)
				
				var vertex3 = _get_vertex(x, y + 0.5)
				var vertex4 = _get_vertex(x + 1, y)
				var vertex5 = _get_vertex(x + 1, y + 1)
				
				var vertex6 = _get_vertex(x, y + 0.5)
				var vertex7 = _get_vertex(x + 1, y + 1)
				var vertex8 = _get_vertex(x, y + 1)
				
				vertices.push_back(vertex0)
				vertices.push_back(vertex1)
				vertices.push_back(vertex2)
				vertices.push_back(vertex3)
				vertices.push_back(vertex4)
				vertices.push_back(vertex5)
				vertices.push_back(vertex6)
				vertices.push_back(vertex7)
				vertices.push_back(vertex8)
				
				continue
			
			if y == 0:
				var vertex0 = _get_vertex(x, y)
				var vertex1 = _get_vertex(x + 0.5, y)
				var vertex2 = _get_vertex(x, y + 1)
				
				var vertex3 = _get_vertex(x + 0.5, y)
				var vertex4 = _get_vertex(x + 1, y)
				var vertex5 = _get_vertex(x + 1, y + 1)
				
				var vertex6 = _get_vertex(x + 0.5, y)
				var vertex7 = _get_vertex(x + 1, y + 1)
				var vertex8 = _get_vertex(x, y + 1)
				
				vertices.push_back(vertex0)
				vertices.push_back(vertex1)
				vertices.push_back(vertex2)
				vertices.push_back(vertex3)
				vertices.push_back(vertex4)
				vertices.push_back(vertex5)
				vertices.push_back(vertex6)
				vertices.push_back(vertex7)
				vertices.push_back(vertex8)
				
				continue
			
			var vertex0 = _get_vertex(x, y)
			var vertex1 = _get_vertex(x + 1, y)
			var vertex2 = _get_vertex(x, y + 1)
			
			var vertex3 = _get_vertex(x + 1, y)
			var vertex4 = _get_vertex(x + 1, y + 1)
			var vertex5 = _get_vertex(x, y + 1)
			
			vertices.push_back(vertex0)
			vertices.push_back(vertex1)
			vertices.push_back(vertex2)
			vertices.push_back(vertex3)
			vertices.push_back(vertex4)
			vertices.push_back(vertex5)

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = arr_mesh

func _process(delta: float) -> void:
	var pos := Vector2(_camera.position.x + TILE_SIZE / 2, _camera.position.z + TILE_SIZE / 2) / TILE_SIZE
	pos = pos.floor()
	
	if _snapped_pos.is_equal_approx(pos):
		return
	
	_snapped_pos = pos
	_reload(pos)

func _get_vertex(x: float, y: float) -> Vector3:
	var offset := Vector3(float(TILE_SIZE) / 2.0, 0.0, float(TILE_SIZE) / 2.0)
	return ((Vector3(x, 0.0, y) / TILE_RESOLUTION) * TILE_SIZE) - offset

func _reload(pos: Vector2) -> void:
	return
	
	print(pos)
	print("Reloading terrain...")
