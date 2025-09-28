extends Node3D
class_name TerrainChunk

@onready var mesh: MeshInstance3D = $Mesh

@export_range(20, 400, 1) var terrain_size: int = 200
@export_range(1, 100, 1) var terrain_resolution: int = 1

@export var terrain_height_multiplier: int = 5
@export var chunk_lods: Array[int] = [2, 4, 8, 15, 20, 50]
@export var LOD_distances: Array[int] = [1200, 1000, 800, 600, 400, 200]

var position_coordinades: Vector2 = Vector2()
var grid_coordinades: Vector2 = Vector2()
var mutex: Mutex = Mutex.new()
var vertices: PackedVector3Array = PackedVector3Array()
var UVs: PackedVector2Array = PackedVector2Array()

const center_offset: float = 0.5

var set_collision: bool = false
var request_generation: bool = false
var generating: bool = false
var completed: bool = false
var can_create_collision: bool = false

var noise: FastNoiseLite

func _ready() -> void:
	match Globals.game_data_dictionary.terrain_quality:
		0:
			chunk_lods = [2, 4, 8, 10, 15, 35]
		1:
			chunk_lods = [3, 5, 10, 15, 20, 50]
		2:
			chunk_lods = [4, 7, 15, 25, 50, 80]
		3:
			chunk_lods = [5, 10, 20, 30, 60, 100]

func generate_terrain(_noise: FastNoiseLite, coordinades: Vector2, size: float, initially_visible: bool, thread = null) -> void:
	terrain_size = size
	noise = _noise
	grid_coordinades = coordinades
	position_coordinades = coordinades * size
	
	var surftool = SurfaceTool.new()
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(terrain_resolution + 1):
		for x in range(terrain_resolution + 1):
			var percent = Vector2(x, z) / terrain_resolution
			var point_on_mesh = Vector3(percent.x - center_offset, 0, percent.y - center_offset)
			var vertex = point_on_mesh * terrain_size
			vertex.y = noise.get_noise_2d(position.x + vertex.x, position.z + vertex.z) * terrain_height_multiplier
			surftool.set_uv(percent)
			surftool.add_vertex(vertex)
	var vert = 0
	for z in range(terrain_resolution):
		for x in range(terrain_resolution):
			surftool.add_index(vert)
			surftool.add_index(vert + 1)
			surftool.add_index(vert + terrain_resolution + 1)
			surftool.add_index(vert + terrain_resolution + 1)
			surftool.add_index(vert + 1)
			surftool.add_index(vert + terrain_resolution + 2)
			vert += 1
		vert += 1
	
	surftool.generate_normals()
	mesh.mesh = surftool.commit()
	set_chunk_visible(initially_visible)
	call_deferred("thread_complete", thread)

func thread_complete(thread: Thread) -> void:
	if thread:
		thread.wait_to_finish()
	if set_collision:
		generate_collision()
		can_create_collision = true
	
func generate_collision() -> void:
	for i in mesh.get_children():
		i.queue_free()
	if set_collision:
		mesh.create_trimesh_collision()

func update_chunk(view_position: Vector2, max_view_distance: float) -> void:
	var viewer_distance = position_coordinades.distance_to(view_position)
	set_chunk_visible(viewer_distance <= max_view_distance)

func should_remove(view_position: Vector2, max_view_distance: float) -> bool:
	return position_coordinades.distance_to(view_position) > max_view_distance

func update_lod(view_position: Vector2):
	if chunk_lods.size() != LOD_distances.size():
		return false
	var viewer_distance = position_coordinades.distance_to(view_position)
	var new_lod = chunk_lods[0]
	
	for i in range(chunk_lods.size()):
		if viewer_distance <= LOD_distances[i]:
			new_lod = chunk_lods[i]
	
	set_collision = new_lod >= 30
	print(new_lod)
	if new_lod >= 15:
		$VegetationSpawner.generate()
	else:
		$VegetationSpawner.clear()
	
	if terrain_resolution != new_lod:
		terrain_resolution = new_lod
		$Label3D.text = str(terrain_resolution)
		return true
	return false

func free_chunk() -> void:
	queue_free()

func set_chunk_visible(_is_visible: bool) -> void:
	if _is_visible == false:
		if mesh.get_child_count() > 0:
			mesh.get_child(0).get_child(0).disabled = true
	else:
		if mesh.get_child_count() > 0:
			mesh.get_child(0).get_child(0).disabled = false
	visible = _is_visible

func get_chunk_visible() -> bool:
	return visible
