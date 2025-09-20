extends Camera3D

var mesh_original_materials = {}
var current_hovered_mesh = null

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * 1000

	var space_state = get_world_3d().direct_space_state

	var ray_params = PhysicsRayQueryParameters3D.new()
	ray_params.from = from
	ray_params.to = to
	ray_params.collide_with_bodies = true
	ray_params.collide_with_areas = true

	var result = space_state.intersect_ray(ray_params)

	if result:
		var mesh = result.get("collider").get_parent()
		if mesh != current_hovered_mesh:
			_reset_previous_mesh()
			_highlight_mesh(mesh)
			current_hovered_mesh = mesh
	else:
		_reset_previous_mesh()
		current_hovered_mesh = null

func _highlight_mesh(mesh: MeshInstance3D):
	if mesh.get_surface_override_material_count() == 0:
		return
	var mat = mesh.get_active_material(0)
	if mat:
		mesh_original_materials[mesh] = mat
		var mat_copy = StandardMaterial3D.new()
		mat_copy.albedo_color = Color(1,1,0)
		mesh.set_surface_override_material(0, mat_copy)

func _reset_previous_mesh():
	if current_hovered_mesh:
		if mesh_original_materials.has(current_hovered_mesh):
			current_hovered_mesh.set_surface_override_material(0, mesh_original_materials[current_hovered_mesh])
			mesh_original_materials.erase(current_hovered_mesh)
