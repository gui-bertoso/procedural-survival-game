extends CollisionShape3D

@export var generate: bool = false
@export var clear: bool = false

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

var generating_bush: bool = false
var generating_stones: bool = false
var generating_trees: bool = false
var generating_mushrooms: bool = false
var generating_grass: bool = false

var count: int = 0

var cleaning: bool = false

func _ready() -> void:
	terrain_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	terrain_noise.seed = Globals.world_data_dictionary.map_noise_seed
	terrain_noise.frequency = Globals.world_data_dictionary.map_noise_frequency
	terrain_noise.fractal_lacunarity = Globals.world_data_dictionary.map_noise_lacunality
	terrain_noise.fractal_gain = Globals.world_data_dictionary.map_noise_gain
	terrain_noise.fractal_weighted_strength = Globals.world_data_dictionary.map_noise_strenght

var generated: bool = false

func _process(_delta: float) -> void:
	if generate and not generated:
		generate = false
		generating_grass = true
		generated = true
		count = 0
	
	if clear or (generated and generate == false):
		clear = false
		generating_bush = false
		generating_grass = false
		generating_mushrooms = false
		generating_stones = false
		generating_trees = false
		cleaning = true
	
	if cleaning:
		if get_child_count() > 0:
			get_child(-1).queue_free()
		else:
			cleaning = false
			generated = false
		return
	
	if generating_grass:
		if count < grass_quantity:
			for i in range(2):
				count += 1
				var a: Node3D = grass_list[randi_range(0, grass_list.size()-1)].instantiate()
				a.global_position = get_random_position()
				add_child(a)
		else:
			generating_grass = false
			generating_mushrooms = true
			count = 0
	if generating_mushrooms:
		if count < mushrooms_quantity:
			for i in range(2):
				count += 1
				var a: Node3D = mushrooms_list[randi_range(0, mushrooms_list.size()-1)].instantiate()
				a.global_position = get_random_position()
				a.scale = Vector3(0.5, 0.5, 0.5)
				add_child(a)
		else:
			generating_mushrooms = false
			generating_bush = true
			count = 0
	if generating_bush:
		if count < bush_quantity:
			for i in range(2):
				count += 1
				var a: Node3D = bushs_list[randi_range(0, bushs_list.size()-1)].instantiate()
				a.global_position = get_random_position()
				add_child(a)
		else:
			generating_bush = false
			generating_stones = true
			count = 0
	if generating_stones:
		if count < stones_quantity:
			for i in range(2):
				count += 1
				var rp: Vector3 = get_random_position()
				if stones_noise.get_noise_2d(rp.x, rp.z) * 10 > 0.12:
					var a: Node3D = stones_list[randi_range(0, stones_list.size()-1)].instantiate()
					a.global_position = rp
					a.scale = Vector3(2, 2, 2)
					add_child(a)
		else:
			generating_stones = false
			generating_trees = true
			count = 0
	if generating_trees:
		if count < trees_quantity:
			for i in range(2):
				count += 1
				var rp: Vector3 = get_random_position()
				if trees_noise.get_noise_2d(rp.x, rp.z) * 10 > 0.07:
					var a: Node3D = trees_list[randi_range(0, trees_list.size()-1)].instantiate()
					a.global_position = rp
					a.scale = Vector3(2, 2, 2)
					add_child(a)
		else:
			generating_trees = false
			count = 0

func get_random_position() -> Vector3:
	var x: float = 0
	var z: float = 0
	var y: float = 1
	
	x = randf_range(-shape.size.x/2, shape.size.x/2)
	z = randf_range(-shape.size.z/2, shape.size.z/2)
	
	y = terrain_noise.get_noise_2d(
		x + global_position.x,
		z + global_position.z
	) * terrain_height_multiplier
	
	return Vector3(x, y, z)
