extends ColorRect

var can_click = false

var modification = null
var node = null

func set_mod(mod: GunModification):
	$TextureRect.texture = mod.modification_image
	$Label.text = mod.modification_name.to_snake_case().replace("_", " ").capitalize()
	modification = mod

func _process(delta: float) -> void:
	if can_click:
		if Input.is_action_just_pressed("ui_select"):
			node.select_modification(modification)

func _on_mouse_entered() -> void:
	color = Color("878700ff")
	can_click = true

func _on_mouse_exited() -> void:
	color = Color("1e1e1e")
	can_click = false
