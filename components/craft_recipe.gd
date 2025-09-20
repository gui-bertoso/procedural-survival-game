extends ColorRect
class_name CraftRecipe

var item = null

var craft_interface = null

var can_click = false
var selected = false

func set_item(_item):
	item = _item.duplicate(true)
	$HBoxContainer/TextureRect.texture = item.item_image
	$HBoxContainer/Label.text = item.item_name.to_snake_case().replace("_", " ").capitalize()

func _process(delta: float) -> void:
	if can_click:
		if Input.is_action_just_pressed("ui_select"):
			match selected:
				true:
					selected = false
					craft_interface.unselect_recipe()
					color = Color(0.1, 0.1, 0.1)
				false:
					selected = true
					craft_interface.select_recipe(self)
					color = Color(0.6, 0.6, 0.2)

func _on_mouse_entered() -> void:
	print("ENTERED")
	if selected:
		color = Color(0.9, 0.9, 0.5)
	else:
		color = Color(0.2, 0.2, 0.2)
	can_click = true

func _on_mouse_exited() -> void:
	print("EXITED")
	if selected:
		color = Color(0.6, 0.6, 0.2)
	else:
		color = Color(0.1, 0.1, 0.1)
	can_click = false
