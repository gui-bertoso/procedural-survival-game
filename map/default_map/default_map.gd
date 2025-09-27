extends Node3D

@onready var map_generator: TerrainChunkManager = $MapGenerator
@onready var loading_screen: LoadingScreen = $LoadingScreen

func _process(_delta: float) -> void:
	if loading_screen:
		if map_generator.is_map_ready():
			loading_screen.queue_free()
			loading_screen = null
