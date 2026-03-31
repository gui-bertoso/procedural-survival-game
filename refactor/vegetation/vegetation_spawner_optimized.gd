extends Node3D
class_name OptimizedVegetationSpawner

@export_category("density")
@export var grass_quantity: int = 180
@export var bush_quantity: int = 60
@export var trees_quantity: int = 80
@export var stones_quantity: int = 30
@export var mushrooms_quantity: int = 10
@export var max_heavy_instances_per_frame: int = 12

@export_category("world")
@export var area_size: Vector2 = Vector2(200.0, 200.0)
@export var terrain_noise: FastNoiseLite
@export var terrain_height_multiplier: float = 20.0
@export var trees_noise: FastNoiseLite
@export var stones_noise: FastNoiseLite

@export_category("assets")
@export var grass_scenes: Array[PackedScene] = []
@export var bush_scenes: Array[PackedScene] = []
@export var tree_scenes: Array[PackedScene] = []
@export var stone_scenes: Array[PackedScene] = []
@export var mushroom_scenes: Array[PackedScene] = []

var _generated := false
var _spawn_queue: Array[Dictionary] = []
var _spawned_heavy: Array[Node3D] = []
var _foliage_multimeshes: Array[MultiMeshInstance3D] = []

func _process(_delta: float) -> void:
	if _spawn_queue.is_empty():
		return
	var budget := max_heavy_instances_per_frame
	while budget > 0 and not _spawn_queue.is_empty():
		var data: Dictionary = _spawn_queue.pop_front()
		_spawn_heavy_scene(data.scene, data.position, data.scale)
		budget -= 1

func generate() -> void:
	if _generated:
		return
	_clear_runtime_only()
	_build_multimesh_foliage(grass_scenes, grass_quantity, Vector3.ONE, 1.0)
	_build_multimesh_foliage(bush_scenes, bush_quantity, Vector3.ONE, 0.35)
	_build_multimesh_foliage(mushroom_scenes, mushrooms_quantity, Vector3(0.5, 0.5, 0.5), 1.0)
	_enqueue_heavy_instances(stone_scenes, stones_quantity, stones_noise, 0.12, Vector3(2.0, 2.0, 2.0))
	_enqueue_heavy_instances(tree_scenes, trees_quantity, trees_noise, 0.07, Vector3(2.0, 2.0, 2.0))
	_generated = true

func clear() -> void:
	_spawn_queue.clear()
	_clear_runtime_only()
	_generated = false

func _clear_runtime_only() -> void:
	for node in _spawned_heavy:
		if is_instance_valid(node):
			node.queue_free()
	_spawned_heavy.clear()
	for mm in _foliage_multimeshes:
		if is_instance_valid(mm):
			mm.queue_free()
	_foliage_multimeshes.clear()

func _build_multimesh_foliage(scene_list: Array[PackedScene], count: int, base_scale: Vector3, noise_threshold: float) -> void:
	if scene_list.is_empty() or count <= 0:
		return
	var source_scene := scene_list[randi_range(0, scene_list.size() - 1)]
	var source_root := source_scene.instantiate()
	var source_mesh_instance := _find_mesh_instance(source_root)
	if source_mesh_instance == null or source_mesh_instance.mesh == null:
		source_root.queue_free()
		return
	var multi_mesh := MultiMesh.new()
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh.mesh = source_mesh_instance.mesh
	multi_mesh.instance_count = count
	var mm_instance := MultiMeshInstance3D.new()
	mm_instance.multimesh = multi_mesh
	add_child(mm_instance)
	_foliage_multimeshes.append(mm_instance)
	source_root.queue_free()
	for i in range(count):
		var pos := _get_random_position()
		var transform := Transform3D(Basis().scaled(base_scale), pos)
		multi_mesh.set_instance_transform(i, transform)

func _enqueue_heavy_instances(scene_list: Array[PackedScene], count: int, noise_source: FastNoiseLite, threshold: float, scale_value: Vector3) -> void:
	if scene_list.is_empty() or count <= 0:
		return
	var placed := 0
	var guard := 0
	while placed < count and guard < count * 20:
		guard += 1
		var pos := _get_random_position()
		if noise_source != null and noise_source.get_noise_2d(pos.x, pos.z) * 10.0 <= threshold:
			continue
		_spawn_queue.append({
			"scene": scene_list[randi_range(0, scene_list.size() - 1)],
			"position": pos,
			"scale": scale_value
		})
		placed += 1

func _spawn_heavy_scene(scene: PackedScene, pos: Vector3, scale_value: Vector3) -> void:
	if scene == null:
		return
	var instance := scene.instantiate()
	if instance is Node3D:
		instance.position = pos
		instance.scale = scale_value
		add_child(instance)
		_spawned_heavy.append(instance)
	else:
		instance.queue_free()

func _get_random_position() -> Vector3:
	var x := randf_range(-area_size.x * 0.5, area_size.x * 0.5)
	var z := randf_range(-area_size.y * 0.5, area_size.y * 0.5)
	var world_x := x + global_position.x
	var world_z := z + global_position.z
	var y := 0.0
	if terrain_noise != null:
		y = terrain_noise.get_noise_2d(world_x, world_z) * terrain_height_multiplier
	return Vector3(x, y, z)

func _find_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var found := _find_mesh_instance(child)
		if found != null:
			return found
	return null
