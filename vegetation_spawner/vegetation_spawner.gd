extends CollisionShape3D

@export_category("Quantitys")
@export var grass_quantity: int = 100
@export var bush_quantity: int = 30
@export var trees_quantity: int = 40
@export var stones_quantity: int = 30
@export var mushrooms_quantity: int = 12

@export var terrain_noise: FastNoiseLite = null
@export var terrain_height_multiplier: float = 20.0
@export var trees_noise: FastNoiseLite = null
@export var stones_noise: FastNoiseLite = null

var visibility_end_distance: float = 0.0

# ---------- LISTAS ----------
var bushs_list: Array[PackedScene] = [
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_bush_1.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_bush_2.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_bush_3.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_bush_4.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_bush_5.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_001.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_002.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_003.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_004.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_005.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_006.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_007.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_008.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_009.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_010.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_011.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_012.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Bush_temp_climate_013.fbx")
]

var grass_list: Array[PackedScene] = [
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_grass_1.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_grass_2.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Grass_001.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Grass_002.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Grass_003.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Grass_004.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Grass_005.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Grass_006.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Grass_007.fbx")
]

var trees_list: Array[PackedScene] = [
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_001.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_002.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_003.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_004.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_005.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_006.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_007.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_008.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_009.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_010.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_011.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_012.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_013.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_014.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_015.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_016.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_017.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_018.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_019.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_020.FBX"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Tree_temp_climate_021.FBX")
]

var stones_list: Array[PackedScene] = [
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_stones_1.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_stone_2.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_stone_3.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_001.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_002.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_003.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_004.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_005.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_006.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_007.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_008.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_009.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_big_010.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_001.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_002.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_003.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_004.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_005.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_006.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_007.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_008.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_009.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_010.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_011.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_012.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_013.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_014.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_015.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_016.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_017.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_018.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_019.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_lit_020.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_001.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_002.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_003.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_004.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_005.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_006.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_007.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_008.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_009.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/Stone_mid_010.fbx")
]

var mushrooms_list: Array[PackedScene] = [
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_mashroom_1.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_mashroom_2.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_mashroom_3.fbx"),
	preload("res://assets/meshs/temporary_thirdparty_mehs/fbx/_mashroom_4.fbx")
]

# ---------- THREAD CONTROL ----------
var _thread: Thread
var _mutex := Mutex.new()
var _instances_to_add: Array = []
var _generating: bool = false
var _generated: bool = false

var lod: float = 0.22

func _ready() -> void:
	visibility_end_distance = 100.0 * (1 + Globals.game_data_dictionary.vegetation_quality)
	match Globals.game_data_dictionary.vegetation_quality:
		0:
			lod = 0.12
		1:
			lod = 0.22
		2:
			lod = 0.34
		3:
			lod = 0.4
	terrain_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	terrain_noise.seed = Globals.world_data_dictionary.map_noise_seed
	terrain_noise.frequency = Globals.world_data_dictionary.map_noise_frequency
	terrain_noise.fractal_lacunarity = Globals.world_data_dictionary.map_noise_lacunality
	terrain_noise.fractal_gain = Globals.world_data_dictionary.map_noise_gain
	terrain_noise.fractal_weighted_strength = Globals.world_data_dictionary.map_noise_strenght

func _process(_delta: float) -> void:
	if _instances_to_add.size() > 0:
		_mutex.lock()
		for inst in _instances_to_add:
			add_child(inst)
		_instances_to_add.clear()
		_mutex.unlock()
		_generating = false
		_generated = true

func generate() -> void:
	if _generating or _generated:
		return
	_generating = true
	_thread = Thread.new()
	_thread.start(Callable(self, "_thread_generate"))

func clear() -> void:
	if _generating:
		_thread.wait_to_finish()
	for child in get_children():
		child.queue_free()
	_generated = false
	_generating = false

func _thread_generate() -> void:
	var new_instances: Array = []

	# Grass
	for i in grass_quantity:
		var inst: Node3D = grass_list[randi_range(0, grass_list.size()-1)].instantiate()
		inst.global_position = get_random_position()
		inst.get_child(0).set("lod_bias", lod)
		inst.get_child(0).set("visibility_range_end", visibility_end_distance)
		new_instances.append(inst)

	# Mushrooms
	for i in mushrooms_quantity:
		var inst: Node3D = mushrooms_list[randi_range(0, mushrooms_list.size()-1)].instantiate()
		inst.global_position = get_random_position()
		inst.scale = Vector3(0.5, 0.5, 0.5)
		inst.get_child(0).set("visibility_range_end", visibility_end_distance)
		inst.get_child(0).set("lod_bias", lod)
		new_instances.append(inst)

	# Bushes
	for i in bush_quantity:
		var inst: Node3D = bushs_list[randi_range(0, bushs_list.size()-1)].instantiate()
		inst.global_position = get_random_position()
		inst.get_child(0).set("visibility_range_end", visibility_end_distance)
		inst.get_child(0).set("lod_bias", lod)
		new_instances.append(inst)

	# Stones
	var placed_stones := 0
	while placed_stones < stones_quantity:
		var rp: Vector3 = get_random_position()
		if stones_noise.get_noise_2d(rp.x, rp.z) * 10 > 0.12:
			var inst: Node3D = stones_list[randi_range(0, stones_list.size()-1)].instantiate()
			inst.global_position = rp
			inst.get_child(0).set("visibility_range_end", visibility_end_distance)
			inst.get_child(0).set("lod_bias", lod)
			inst.scale = Vector3(2, 2, 2)
			new_instances.append(inst)
			placed_stones += 1

	# Trees
	var placed_trees := 0
	while placed_trees < trees_quantity:
		var rp: Vector3 = get_random_position()
		if trees_noise.get_noise_2d(rp.x, rp.z) * 10 > 0.07:
			var inst: Node3D = trees_list[randi_range(0, trees_list.size()-1)].instantiate()
			inst.global_position = rp
			inst.get_child(0).set("visibility_range_end", visibility_end_distance)
			inst.get_child(0).set("lod_bias", lod)
			inst.scale = Vector3(2, 2, 2)
			new_instances.append(inst)
			placed_trees += 1

	# Passa para a main thread
	_mutex.lock()
	_instances_to_add = new_instances
	_mutex.unlock()

func get_random_position() -> Vector3:
	var x = randf_range(-shape.size.x/2, shape.size.x/2)
	var z = randf_range(-shape.size.z/2, shape.size.z/2)
	var y = terrain_noise.get_noise_2d(
		x + global_position.x,
		z + global_position.z
	) * terrain_height_multiplier
	return Vector3(x, y, z)
