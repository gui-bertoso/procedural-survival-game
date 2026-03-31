extends Node3D
class_name ChunkStreamManager

@export var viewer: Node3D
@export var chunk_scene: PackedScene
@export var noise: FastNoiseLite

@export var chunk_size: int = 128
@export var view_distance_chunks: int = 4
@export var max_chunk_updates_per_frame: int = 2

var _loaded_chunks: Dictionary = {}
var _chunk_pool: Array[StreamedTerrainChunk] = []
var _pending_updates: Array[Vector2i] = []

func _process(_delta: float) -> void:
	if viewer == null:
		return
	_update_visible_set()
	_process_pending_updates()

func _update_visible_set() -> void:
	var player_chunk := _world_to_chunk(viewer.global_position)
	var required := {}

	for x in range(player_chunk.x - view_distance_chunks, player_chunk.x + view_distance_chunks + 1):
		for z in range(player_chunk.y - view_distance_chunks, player_chunk.y + view_distance_chunks + 1):
			var key := Vector2i(x, z)
			required[key] = true
			if not _loaded_chunks.has(key):
				_load_chunk(key)
				_pending_updates.append(key)

	for key in _loaded_chunks.keys():
		if not required.has(key):
			_unload_chunk(key)

func _process_pending_updates() -> void:
	var processed := 0
	while processed < max_chunk_updates_per_frame and _pending_updates.size() > 0:
		var key := _pending_updates.pop_front()
		var chunk: StreamedTerrainChunk = _loaded_chunks.get(key)
		if chunk:
			var distance := chunk.global_position.distance_to(viewer.global_position)
			chunk.request_lod(distance)
		processed += 1

func _load_chunk(key: Vector2i) -> void:
	var chunk := _get_chunk_instance()
	chunk.configure(key, chunk_size, 20.0, noise)
	add_child(chunk)
	_loaded_chunks[key] = chunk

func _unload_chunk(key: Vector2i) -> void:
	var chunk: StreamedTerrainChunk = _loaded_chunks[key]
	_loaded_chunks.erase(key)
	_return_chunk(chunk)

func _get_chunk_instance() -> StreamedTerrainChunk:
	if _chunk_pool.size() > 0:
		var chunk := _chunk_pool.pop_back()
		chunk.set_active(true)
		return chunk
	return chunk_scene.instantiate()

func _return_chunk(chunk: StreamedTerrainChunk) -> void:
	chunk.set_active(false)
	chunk.get_parent().remove_child(chunk)
	_chunk_pool.append(chunk)

func _world_to_chunk(pos: Vector3) -> Vector2i:
	return Vector2i(floor(pos.x / chunk_size), floor(pos.z / chunk_size))
