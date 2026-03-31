extends Node3D
class_name StreamedTerrainChunk

signal mesh_generated(chunk: StreamedTerrainChunk)

@export var mesh_instance: MeshInstance3D
@export_range(16, 512, 1) var terrain_size: int = 128
@export var terrain_height_multiplier: float = 20.0
@export var collision_lod_threshold: int = 32
@export var chunk_lods: Array[int] = [4, 8, 12, 20, 32, 48]
@export var lod_distances: Array[float] = [180.0, 300.0, 500.0, 800.0, 1200.0, 1800.0]

var chunk_key: Vector2i = Vector2i.ZERO
var current_lod: int = -1
var current_noise: FastNoiseLite
var current_mesh: ArrayMesh
var generating := false
var _queued_lod := -1

func _ready() -> void:
	if mesh_instance == null:
		mesh_instance = $Mesh

func configure(key: Vector2i, size: int, height_multiplier: float, noise: FastNoiseLite) -> void:
	chunk_key = key
	terrain_size = size
	terrain_height_multiplier = height_multiplier
	current_noise = noise
	global_position = Vector3(key.x * terrain_size, 0.0, key.y * terrain_size)
	visible = true

func set_active(value: bool) -> void:
	visible = value
	process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED
	if not value and mesh_instance:
		mesh_instance.visible = false
	elif mesh_instance:
		mesh_instance.visible = true

func request_lod(distance_to_viewer: float) -> void:
	var lod := _pick_lod(distance_to_viewer)
	if lod == current_lod:
		return
	if generating:
		_queued_lod = lod
		return
	_generate_mesh(lod)

func _pick_lod(distance_to_viewer: float) -> int:
	if chunk_lods.is_empty():
		return 8
	var selected := chunk_lods.back()
	for i in range(min(chunk_lods.size(), lod_distances.size())):
		if distance_to_viewer <= lod_distances[i]:
			selected = chunk_lods[i]
			break
	return max(2, selected)

func _generate_mesh(target_lod: int) -> void:
	if current_noise == null:
		return
	generating = true
	_queued_lod = -1
	var arrays := _build_mesh_arrays(target_lod)
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	current_mesh = array_mesh
	current_lod = target_lod
	mesh_instance.mesh = current_mesh
	if target_lod >= collision_lod_threshold:
		_call_collision_refresh()
	else:
		_clear_collision()
	generating = false
	mesh_generated.emit(self)
	if _queued_lod != -1 and _queued_lod != current_lod:
		_generate_mesh(_queued_lod)

func _build_mesh_arrays(resolution: int) -> Array:
	var vertex_count := (resolution + 1) * (resolution + 1)
	var vertices := PackedVector3Array()
	vertices.resize(vertex_count)
	var normals := PackedVector3Array()
	normals.resize(vertex_count)
	var uvs := PackedVector2Array()
	uvs.resize(vertex_count)
	var indices := PackedInt32Array()
	indices.resize(resolution * resolution * 6)
	
	var inv_resolution := 1.0 / float(resolution)
	var vertex_index := 0
	for z in range(resolution + 1):
		for x in range(resolution + 1):
			var percent_x := x * inv_resolution
			var percent_z := z * inv_resolution
			var local_x := (percent_x - 0.5) * terrain_size
			var local_z := (percent_z - 0.5) * terrain_size
			var world_x := global_position.x + local_x
			var world_z := global_position.z + local_z
			var height := current_noise.get_noise_2d(world_x, world_z) * terrain_height_multiplier
			vertices[vertex_index] = Vector3(local_x, height, local_z)
			uvs[vertex_index] = Vector2(percent_x, percent_z)
			vertex_index += 1
	
	var index := 0
	for z in range(resolution):
		for x in range(resolution):
			var top_left := z * (resolution + 1) + x
			var top_right := top_left + 1
			var bottom_left := top_left + resolution + 1
			var bottom_right := bottom_left + 1
			indices[index] = top_left
			indices[index + 1] = top_right
			indices[index + 2] = bottom_left
			indices[index + 3] = bottom_left
			indices[index + 4] = top_right
			indices[index + 5] = bottom_right
			index += 6
	
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices
	return arrays

func _call_collision_refresh() -> void:
	_clear_collision()
	mesh_instance.create_trimesh_collision()

func _clear_collision() -> void:
	for child in mesh_instance.get_children():
		child.queue_free()
