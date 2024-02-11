@tool
extends Node3D

const TERRAIN_MATERIAL = preload("res://shaders/terrain.tres")

const TILE_RESOLUTION: int = 48
const TILE_SIZE: float = 24.0
const MAX_LODS: int = 5

const MAP_SIZE: int = 5

@export var update: bool = true

@onready var _camera: Camera3D = EditorInterface.get_editor_viewport_3d().get_camera_3d()

var _lods: Array[Dictionary]
var _instances: Array[MeshInstance3D]

func _ready() -> void:
	_lods = _generate_lods()

	for y: int in MAP_SIZE:
		for x: int in MAP_SIZE:
			var pos = Vector2(x, y) - (Vector2(MAP_SIZE, MAP_SIZE) / 2.0).floor()

			var mesh_instance := MeshInstance3D.new()
			mesh_instance.material_override = TERRAIN_MATERIAL
			mesh_instance.position = Vector3(pos.x, 0.0, pos.y) * TILE_SIZE
			
			mesh_instance.mesh = _lods[0][Vector2i.ZERO]
			mesh_instance.custom_aabb = AABB(Vector3(-12, 0, -12), Vector3(24, 16, 24))
			
			add_child(mesh_instance)
			_instances.append(mesh_instance)
	
	_check_position()

func _process(delta: float) -> void:
	_check_position()

func _generate_lods() -> Array[Dictionary]:
	var lods: Array[Dictionary] = []
	
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var resolution: int = TILE_RESOLUTION
	
	while lods.size() < MAX_LODS:
		var lod := {}
		
		for y: int in range(-1, 2):
			for x: int in range(-1, 2):
				var direction := Vector2i(x, y)
				
				arrays[Mesh.ARRAY_VERTEX] = TerrainMesh.create_center_tile(TILE_SIZE, resolution)
				
				if direction == Vector2i.UP:
					arrays[Mesh.ARRAY_VERTEX] = TerrainMesh.create_side_tile(TILE_SIZE, resolution)
				
				var mesh := ArrayMesh.new()
				mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
				
				lod[direction] = mesh
		
		lods.append(lod)
		resolution /= 2
	
	return lods

func _check_position() -> void:
	var pos := Vector2(_camera.global_position.x, _camera.global_position.z)
	pos += Vector2(TILE_SIZE, TILE_SIZE) / 2.0
	pos /= TILE_SIZE
	pos = pos.floor()
	
	if update:
		_reload_tiles(pos)

func _reload_tiles(camera_tile: Vector2i) -> void:
	var size := Vector2i(MAP_SIZE, MAP_SIZE)
	var rect := Rect2i(-size / 2, size)
	
	var tiles := TerrainLOD.get_lods(camera_tile, rect)
	
	for i: int in _instances.size():
		var tile = tiles[i]
		
		var direction := Vector2i(tile.x, tile.y)
		var lod = mini(tile.z, MAX_LODS - 1)
		
		if lod == 0:
			_instances[i].mesh = _lods[0][Vector2i.ZERO]
			continue
		
		_instances[i].mesh = _lods[lod][direction]
