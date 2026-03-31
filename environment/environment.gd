extends Node3D

@export var world_environment: WorldEnvironment = null

func _ready() -> void:
	match Globals.game_data_dictionary.envinroment_quality:
		0:
			world_environment.environment = load("res://environments/very_low_quality_environment.tres")
		1:
			world_environment.environment = load("res://environments/low_quality_environment.tres")
		2:
			world_environment.environment = load("res://environments/medium_quality_environment.tres")
		3:
			world_environment.environment = load("res://environments/high_quality_environment.tres")
