extends RayCast3D
class_name CharacterCamera

func _process(_delta: float) -> void:
	if is_colliding():
		if get_collider() is Structure:
			if "interacting" in get_collider():
				get_collider().interacting = true
