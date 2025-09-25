extends MultiMeshInstance3D
class_name TreeSpawner

@export var tree_density := 50
@export var tree_scale := Vector2(0.8, 1.4)
@export var noise: FastNoiseLite
@export var terrain_ref: Node3D
@export var player: Node3D
@export var collision_distance := 30.0
@export var tree_mesh: Mesh
