extends StaticBody3D
class_name Structure

var interacting = false

func _process(delta: float) -> void:
	if interacting:
		interacting = false
