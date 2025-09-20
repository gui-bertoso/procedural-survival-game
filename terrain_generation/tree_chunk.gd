extends MultiMeshInstance3D
class_name TreeSpawner

@export var tree_density := 50
@export var tree_scale := Vector2(0.8, 1.4)
@export var noise: FastNoiseLite
@export var terrain_ref: Node3D
@export var player: Node3D
@export var collision_distance := 30.0
@export var tree_mesh: Mesh

var colliders := []

func _ready():
	player = Globals.player
	terrain_ref = get_parent()
	multimesh = MultiMesh.new()

	if not tree_mesh:
		var default_mesh = CylinderMesh.new()
		default_mesh.top_radius = 0.3
		default_mesh.bottom_radius = 0.5
		default_mesh.height = 3.0
		tree_mesh = default_mesh

	multimesh.mesh = tree_mesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = tree_density

func generate_trees():
	if not noise or not terrain_ref:
		return

	var rng = RandomNumberGenerator.new()
	rng.seed = int(terrain_ref.grid_coordinades.x * 928371 + terrain_ref.grid_coordinades.y * 123721)

	for i in range(tree_density):
		var x = rng.randf_range(-terrain_ref.terrain_size * 0.5, terrain_ref.terrain_size * 0.5)
		var z = rng.randf_range(-terrain_ref.terrain_size * 0.5, terrain_ref.terrain_size * 0.5)
		var y = noise.get_noise_2d(
			terrain_ref.position_coordinades.x + x,
			terrain_ref.position_coordinades.y + z
		) * terrain_ref.terrain_height_multiplier

		var pos = Vector3(x, y, z)
		var basis = Basis().rotated(Vector3.UP, rng.randf_range(0, TAU))
		var scale_factor = rng.randf_range(tree_scale.x, tree_scale.y)
		basis = basis.scaled(Vector3.ONE * scale_factor)

		var transform = Transform3D(basis, pos)
		multimesh.set_instance_transform(i, transform)

	visible = true

func update_collision():
	if not player or not terrain_ref:
		return

	# 🌲 Limpa colisores antigos automaticamente
	for b in colliders:
		if b and b.is_inside_tree():
			b.queue_free()
	colliders.clear()

	## adiciona colisão apenas para árvores próximas
	#for i in range(multimesh.instance_count):
		#var local_transform = multimesh.get_instance_transform(i)
#
		## transforma para global corretamente
		#var global_basis = terrain_ref.global_transform.basis * local_transform.basis
		#var global_origin = terrain_ref.global_transform.origin + terrain_ref.global_transform.basis * local_transform.origin
		#var global_transform = Transform3D(global_basis, global_origin)
#
		#if global_origin.distance_to(player.global_position) <= collision_distance:
			#var body = StaticBody3D.new()
			#var shape = BoxShape3D.new()
			#shape.size = Vector3(1, 3, 1)  # ajuste conforme a árvore
			#var collider = CollisionShape3D.new()
			#collider.shape = shape
			#collider.transform.origin = Vector3.ZERO
			#body.add_child(collider)
			#body.global_transform = global_transform
			#add_child(body)
			#colliders.append(body)
