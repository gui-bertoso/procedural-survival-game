@tool
extends Node3D

@export var generate: bool = false
@export var clear: bool = false

@export_category("Quantitys")
@export var grass_quantity: int = 100
@export var bush_quantity: int = 30
@export var trees_quantity: int = 40
@export var stones_quantity: int = 30
@export var mushrooms_quantity: int = 12

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
