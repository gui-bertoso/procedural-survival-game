extends Node3D

@export var world_envinroment: WorldEnvironment = null

func _ready() -> void:
	match Globals.game_data_dictionary.envinroment_quality:
		0:
			world_envinroment.environment = load("res://envinroments/very_low_quality_envinroment.tres")
		1:
			world_envinroment.environment = load("res://envinroments/low_quality_envinroment.tres")
		2:
			world_envinroment.environment = load("res://envinroments/medium_quality_envinroment.tres")
		3:
			world_envinroment.environment = load("res://envinroments/high_quality_envinroment.tres")
