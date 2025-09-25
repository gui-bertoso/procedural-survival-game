extends StaticBody3D
class_name Structure

var interacting: bool = false
var a: bool = false

func _process(_delta: float) -> void:
	if interacting:
		if Input.is_action_just_pressed("ui_interact"):
			if not a:
				Globals.hud.show_gun_bench_interface()
				a = true
			else:
				Globals.hud.hide_gun_bench_interface()
				a = false
		interacting = false
