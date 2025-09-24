extends Structure
class_name DebugItemGiver

func _process(delta: float) -> void:
	$Body/Mesh2.rotation.y += delta
	$Collision2.rotation.y += delta
	if randi_range(0, 1) == 1:
		$Body/Mesh2.global_position.y += delta/10
	else:
		$Body/Mesh2.global_position.y -= delta/10
	if interacting:
		if Input.is_action_just_pressed("ui_collect"):
			for i in randi_range(1, 3):
				Globals.inventory.add_item(load("res://itens/debug_material.tres"))
		interacting = false
