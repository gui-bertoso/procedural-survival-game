extends Structure
class_name DebugCraftStation

@onready var collision: CollisionShape3D = $Collision2
@onready var mesh: MeshInstance3D = $Body/Mesh2
@onready var craft_data: CraftDataComponent = $CraftData

func _process(delta: float) -> void:
	mesh.global_rotation.y += delta
	collision.global_rotation.y += delta
	if interacting:
		if Input.is_action_just_pressed("ui_interact"):
			if not a:
				Globals.hud.show_craft_interface(craft_data.craft_recipes)
				a = true
			else:
				Globals.hud.hide_craft_interface()
				a = false
		interacting = false
