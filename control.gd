extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$SubViewportContainer/SubViewport/Node3D/Camera3D.global_position.y += (-event.relative.y * 0.0001)
		$SubViewportContainer/SubViewport/Node3D/Camera3D.global_position.x += (-event.relative.x * 0.0001)


func _on_texture_button_button_up() -> void:
	pass # Replace with function body.


func _on_texture_button_2_button_up() -> void:
	pass # Replace with function body.


func _on_texture_button_3_button_up() -> void:
	pass # Replace with function body.


func _on_texture_button_4_button_up() -> void:
	pass # Replace with function body.


func _on_texture_button_5_button_up() -> void:
	pass # Replace with function body.
