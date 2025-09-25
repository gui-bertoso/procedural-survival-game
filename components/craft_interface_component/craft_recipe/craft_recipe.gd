extends ColorRect
class_name CraftRecipe

@export var _item_texture: TextureRect = null
@export var _item_name_label: Label = null

var craft_interface: CraftInterfaceComponent = null

var can_click: bool = false
var selected: bool = false

var item: Item = null

func _process(_delta: float) -> void:
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

func set_item(_item: Item) -> void:
	item = _item.duplicate(true)
	_item_texture.texture = item.item_image
	_item_name_label.text = item.item_name.to_snake_case().replace("_", " ").capitalize()

func unselect() -> void:
	selected = false
	color = Color(0.1, 0.1, 0.1)
	_on_mouse_exited()

func _on_mouse_entered() -> void:
	if selected:
		color = Color(0.9, 0.9, 0.5)
	else:
		color = Color(0.2, 0.2, 0.2)
	can_click = true
func _on_mouse_exited() -> void:
	if selected:
		color = Color(0.6, 0.6, 0.2)
	else:
		color = Color(0.1, 0.1, 0.1)
	can_click = false
