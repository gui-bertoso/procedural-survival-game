@tool
extends Node3D
class_name TerrainChunksManager

# --- EXPORTS ---
@export var camera_node: NodePath

@export_group("World Shape")
@export var chunk_size = 100
@export var vertex_scale = 1.0
@export var height_multiplier = 40.0

@export_group("Noise Settings")
@export var seed = 1337
@export var noise_scale = 200.0
@export var octaves = 6
@export_range(0.0, 1.0) var persistence = 0.6
@export var lacunality = 2.0
@export_range(0.1, 4.0) var exponent_remodeling = 1.8

@export_group("Performance & LOD")
@export var view_distance = 8
# Distâncias para cada LOD. Ex: [150, 300].
# LOD 0: 0-150m, LOD 1: 150-300m, LOD 2: >300m
@export var lod_distances: PackedFloat32Array = [150.0, 300.0, 500.0, 900.0, 1200.0, 1800.0, 2200.0, 2800.0]
@export var update_interval = 1.0

@export_group("Editor Tool & Cache")
@export var center_on_origin_in_editor = false
@export var clear_all_chunks_and_cache = false:
	set(value):
		if value:
			_clear_all_chunks(true)
			clear_all_chunks_and_cache = false

# --- VARIÁVEIS INTERNAS ---
var camera: Camera3D
var noise: FastNoiseLite
var _chunk_scene: PackedScene = preload("res://terrain_generation/terrain_chunk.tscn")
var _loaded_chunks: Dictionary = {}
var _generating_chunks: Dictionary = {}
var _thread_pool: Array[Thread] = []
const MAX_THREADS = 2
var _chunk_world_size: float
var _current_center_chunk_pos: Vector2i = Vector2i(9999, 9999)
var _save_directory = "user://saves/"

# --- MÉTODOS DO GODOT ---
func _ready():
	_chunk_world_size = float(chunk_size * vertex_scale)
	DirAccess.make_dir_absolute(_save_directory)
	_create_noise_object()
	
	for i in MAX_THREADS:
		_thread_pool.append(Thread.new())
	
	if not Engine.is_editor_hint():
		camera = get_node_or_null(camera_node)
		if not camera:
			printerr("Câmera não definida para o modo de jogo!")
			return
		var timer = Timer.new()
		timer.wait_time = update_interval
		timer.autostart = true
		timer.timeout.connect(_on_update_timer_timeout)
		add_child(timer)
		_on_update_timer_timeout()

func _process(delta: float):
	var main_camera = get_viewport().get_camera_3d()
	if not is_instance_valid(main_camera): return
	
	var center_point = main_camera.global_transform.origin
	
	if Engine.is_editor_hint():
		if center_on_origin_in_editor:
			center_point = Vector3.ZERO
		_update_world(center_point) # No editor, o _process faz tudo
	else:
		_update_chunk_lods(center_point) # No jogo, _process só atualiza os LODs

# --- LÓGICA PRINCIPAL ---
func _on_update_timer_timeout():
	if is_instance_valid(camera):
		_update_world(camera.global_transform.origin)

func _update_world(center_point: Vector3):
	var new_center_chunk_pos = Vector2i(roundi(center_point.x / _chunk_world_size), roundi(center_point.z / _chunk_world_size))
	if new_center_chunk_pos == _current_center_chunk_pos:
		return
	_current_center_chunk_pos = new_center_chunk_pos
	_update_chunks()

func _update_chunks():
	# 1. DESCARREGAMENTO E SALVAMENTO EM CACHE
	var chunks_to_unload: Array[Vector2i] = []
	for existing_coord in _loaded_chunks.keys():
		var dist_vector = existing_coord - _current_center_chunk_pos
		if max(abs(dist_vector.x), abs(dist_vector.y)) > view_distance:
			chunks_to_unload.append(existing_coord)
	
	for coord in chunks_to_unload:
		var chunk_node = _loaded_chunks.get(coord)
		if is_instance_valid(chunk_node):
			var mesh_instance = chunk_node.get_node_or_null("MeshInstance3D")
			if mesh_instance and mesh_instance.mesh:
				var filepath = _save_directory.path_join("chunk_%d_%d.res" % [coord.x, coord.y])
				# Só salva a malha de maior qualidade (LOD 0)
				ResourceSaver.save(chunk_node.lod_meshes[0], filepath)
			chunk_node.queue_free()
		_loaded_chunks.erase(coord)

	# 2. CARREGAMENTO
	for r in range(view_distance + 1):
		for x in range(-r, r + 1):
			for z in range(-r, r + 1):
				if r > 0 and abs(x) < r and abs(z) < r: continue
				var chunk_coord = _current_center_chunk_pos + Vector2i(x, z)
				if not _loaded_chunks.has(chunk_coord) and not _generating_chunks.has(chunk_coord):
					_request_chunk_generation(chunk_coord)

func _update_chunk_lods(camera_pos: Vector3):
	lod_distances.sort()
	for coord in _loaded_chunks:
		var chunk_node: TerrainChunk = _loaded_chunks[coord]
		if is_instance_valid(chunk_node):
			var chunk_world_pos = chunk_node.global_transform.origin
			var distance = camera_pos.distance_to(chunk_world_pos)
			
			var new_lod = 0
			for i in range(lod_distances.size()):
				if distance > lod_distances[i]:
					new_lod = i + 1
				else:
					break
			if new_lod >= chunk_node.NUM_LODS:
				new_lod = chunk_node.NUM_LODS - 1
			chunk_node.set_lod_level(new_lod)

func _create_noise_object():
	noise = FastNoiseLite.new()
	noise.seed = seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 1.0 / noise_scale
	noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	noise.fractal_octaves = octaves
	noise.fractal_gain = persistence
	noise.fractal_lacunarity = lacunality

# --- GERENCIAMENTO DE CACHE E THREADS ---
func _request_chunk_generation(coord: Vector2i):
	var filepath = _save_directory.path_join("chunk_%d_%d.res" % [coord.x, coord.y])
	
	if FileAccess.file_exists(filepath):
		var loaded_mesh = ResourceLoader.load(filepath)
		if loaded_mesh is ArrayMesh:
			var chunk_instance: TerrainChunk = _chunk_scene.instantiate()
			# Se carregou do cache, só precisamos do LOD 0
			chunk_instance.lod_meshes.append(loaded_mesh)
			chunk_instance.lod_collision_shapes.append(loaded_mesh.create_trimesh_shape())
			chunk_instance.set_lod_level(0)
			chunk_instance._generate_collision_and_navigation()
			var final_pos = Vector3(coord.x * _chunk_world_size, 0, coord.y * _chunk_world_size)
			_on_chunk_generated(chunk_instance, coord, final_pos, get_tree().edited_scene_root if Engine.is_editor_hint() else self)
	else:
		_start_generation_thread(coord)

func _start_generation_thread(coord: Vector2i):
	_generating_chunks[coord] = true
	var thread = Thread.new()
	var owner_node = get_tree().edited_scene_root if Engine.is_editor_hint() else self
	thread.start(generate_chunk_threaded.bind(coord, owner_node))

func generate_chunk_threaded(coord: Vector2i, owner_node: Node):
	var chunk_instance: TerrainChunk = _chunk_scene.instantiate()
	chunk_instance.generate(noise, Vector2(coord.x, coord.y), chunk_size, vertex_scale, height_multiplier, exponent_remodeling)
	var final_position = Vector3(coord.x * _chunk_world_size, 0, coord.y * _chunk_world_size)
	call_deferred("_on_chunk_generated", chunk_instance, coord, final_position, owner_node)
	
func _on_chunk_generated(chunk: Node3D, coord: Vector2i, pos: Vector3, owner_node: Node):
	if _generating_chunks.has(coord): _generating_chunks.erase(coord)
	chunk.global_position = pos
	add_child(chunk)
	if Engine.is_editor_hint() and is_instance_valid(owner_node):
		chunk.owner = owner_node
	_loaded_chunks[coord] = chunk

# --- FUNÇÃO DE LIMPEZA ---
func _clear_all_chunks(clear_cache: bool = false):
	# Espera threads em execução terminarem
	for node in get_children():
		if node is TerrainChunk:
			node.queue_free()
	_loaded_chunks.clear()
	
	if clear_cache:
		var dir = DirAccess.open(_save_directory)
		if dir:
			var files = dir.get_files()
			for file_name in files:
				dir.remove(file_name)
			print("Cache de chunks limpo em: " + _save_directory)
		
	_current_center_chunk_pos = Vector2i(9999, 9999)
