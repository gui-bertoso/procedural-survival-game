extends Node3D
class_name TerrainChunk

@export_range(20, 400, 1) var terrain_size = 200
@export_range(1, 100, 1) var terrain_resolution = 20

@export var terrain_height_multiplier = 5
@export var chunk_lods: Array[int] = [2, 4, 8, 15, 20, 50]
@export var LOD_distances: Array[int] = [2000, 1500, 1050, 900, 790, 550]

var position_coordinades = Vector2()
var grid_coordinades = Vector2()
var mutex = Mutex.new()
var vertices = PackedVector3Array()
var UVs = PackedVector2Array()

const center_offset = 0.5
var set_collision = false
var request_generation = false
var generating = false
var completed = false

var noise: FastNoiseLite

var can_create_collision = false
func generate_terrain(_noise: FastNoiseLite, coordinades: Vector2, size: float, initially_visible: bool, thread = null):
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
	$Mesh.mesh = surftool.commit()
	set_chunk_visible(initially_visible)
	call_deferred("thread_complete", thread)

func thread_complete(thread):
	if thread:
		thread.wait_to_finish()
	if set_collision:
		generate_collision()
		can_create_collision = true
	
func generate_collision():
	if $Mesh.get_child_count() > 0:
		$Mesh.get_child(0).queue_free()
	if terrain_resolution == 50:
		$Mesh.create_trimesh_collision()

func update_chunk(view_position: Vector2, max_view_distance: float):
	var viewer_distance = position_coordinades.distance_to(view_position)
	set_chunk_visible(viewer_distance <= max_view_distance)
	$ResourcesChunk.update_collision()

func should_remode(view_position: Vector2, max_view_distance: float):
	return position_coordinades.distance_to(view_position) > max_view_distance

func update_lod(view_position: Vector2):
	if chunk_lods.size() != LOD_distances.size():
		print("LOD and DISTANCES mistake")
		return false
	var viewer_distance = position_coordinades.distance_to(view_position)
	var new_lod = chunk_lods[0]
	
	for i in range(chunk_lods.size()):
		if viewer_distance < LOD_distances[i]:
			new_lod = chunk_lods[i]
	
	set_collision = new_lod >= chunk_lods.back()
	
	if noise:
		if new_lod >= 18:
			if not $ResourcesChunk.has_meta("generated"):
				$ResourcesChunk.noise = noise
				$ResourcesChunk.terrain_ref = self
				$ResourcesChunk.generate_trees()
				$ResourcesChunk.set_meta("generated", true)
			
	if terrain_resolution != new_lod:
		terrain_resolution = new_lod
		return true
	return false

func free_chunk():
	queue_free()

func set_chunk_visible(_is_visible: bool):
	visible = _is_visible

func get_chunk_visible():
	return visible
