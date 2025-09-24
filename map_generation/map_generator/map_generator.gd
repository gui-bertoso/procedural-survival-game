extends Node3D
class_name TerrainChunkManager
@export var terrain_chunk_size = 400
@export var terrain_height_multiplier = 20
@export var render_distance = 2000
@export var viewer: Node3D
@export var chunk_mesh_scene: PackedScene = preload("uid://p3u00rljwmwy")
@export var thread_count = 10
@export var noise: FastNoiseLite

var viewer_position = Vector2()
var terrain_chunks = {}
var chunks_visible = 0
var threads: Array[Thread] = []
var active_threads = 0
var last_visible_chunks: Array = []

func _ready() -> void:
	for i in range(thread_count):
		threads.append(Thread.new())
	chunks_visible = roundi(render_distance / terrain_chunk_size)
	update_visible_chunks()

func _process(delta: float) -> void:
	viewer_position = Vector2(viewer.global_position.x, viewer.global_position.z)
	update_visible_chunks()

func update_visible_chunks():
	for chunk in last_visible_chunks:
		chunk.set_chunk_visible(false)
	last_visible_chunks.clear()
	
	var current_x = roundi(viewer_position.x / terrain_chunk_size)
	var current_y = roundi(viewer_position.y / terrain_chunk_size)
	
	for y_offset in range(-chunks_visible, chunks_visible):
		for x_offset in range(-chunks_visible, chunks_visible):
			var coordinades = Vector2(current_x - x_offset, current_y - y_offset)
			
			if terrain_chunks.has(coordinades):
				var chunk = terrain_chunks[coordinades]
				chunk.update_chunk(viewer_position, render_distance)
				if chunk.update_lod(viewer_position):
					chunk.generate_terrain(noise, coordinades, terrain_chunk_size, false)
				if chunk.get_chunk_visible():
					last_visible_chunks.append(chunk)
			else:
				var chunk = chunk_mesh_scene.instantiate()
				add_child(chunk)
				chunk.terrain_height_multiplier = terrain_height_multiplier
				var pos = coordinades * terrain_chunk_size
				chunk.global_position = Vector3(pos.x, 0, pos.y)
				terrain_chunks[coordinades] = chunk
				
				for thread in threads:
					if not thread.is_started():
						thread.start(chunk.generate_terrain.bind(thread, noise, coordinades, terrain_chunk_size, true, thread))
						break

func _exit_tree() -> void:
	for thread in threads:
		if thread.is_alive():
			thread.wait_to_finish()

func get_active_threads():
	active_threads = 0
	for thread in threads:
		if thread.is_alive():
			active_threads += 1
	return active_threads
