extends Structure
class_name DebugItemGiver

@onready var collision: CollisionShape3D = $Collision2
@onready var mesh: MeshInstance3D = $Body/Mesh2

func _process(delta: float) -> void:
	mesh.rotation.y += delta
	collision.rotation.y += delta
	if randi_range(0, 1) == 1:
		mesh.global_position.y += delta/10
	else:
		mesh.global_position.y -= delta/10
	if interacting:
		if Input.is_action_just_pressed("ui_collect"):
			for i in randi_range(1, 3):
				Globals.inventory.add_item(load("res://itens/debug_material.tres"))
		interacting = false
