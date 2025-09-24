extends Structure
class_name DebugCraftStation

func _process(delta: float) -> void:
	$Body/Mesh2.global_rotation.y += delta
	$Collision2.global_rotation.y += delta
	if interacting:
		if Input.is_action_just_pressed("ui_interact"):
			if not a:
				Globals.hud.show_craft_interface($CraftData.craft_recipes)
				a = true
			else:
				Globals.hud.hide_craft_interface()
				a = false
		interacting = false
