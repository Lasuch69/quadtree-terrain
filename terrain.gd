@tool
extends MeshInstance3D

const TILE_RESOLUTION: int = 32
const TILE_SIZE: float = 2.0

const SIZE := Vector2i(3, 3)

@onready var _camera: Camera3D = EditorInterface.get_editor_viewport_3d().get_camera_3d()
var _snapped_pos: Vector2

func _ready() -> void:
	var vertices = PackedVector3Array()
	vertices = TerrainMesh.create_mesh(TILE_SIZE, TILE_RESOLUTION)

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
	var half_tile := float(TILE_SIZE) / 2.0
	var offset := Vector3(half_tile, 0.0, half_tile)
	return ((Vector3(x, 0.0, y) / TILE_RESOLUTION) * TILE_SIZE) - offset

func _reload(pos: Vector2) -> void:
	return
	
	print(pos)
	print("Reloading terrain...")
