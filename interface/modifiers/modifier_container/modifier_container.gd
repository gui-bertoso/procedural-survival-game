extends ColorRect
class_name ModificationRecipe

@onready var item_texture: TextureRect = $ItemTexture
@onready var item_name: Label = $ItemName

var interface: GunsBenchInterfaceComponent = null

var can_click: bool = false
var selected: bool = false

var item: GunModification = null

func set_modification(_item: GunModification) -> void:
	item = _item.duplicate(true)
	item_texture.texture = item.modification_image
	item_name.text = item.modification_name.to_snake_case().replace("_", " ").capitalize()

func _process(_delta: float) -> void:
	if can_click:
		if Input.is_action_just_pressed("ui_select"):
			match selected:
				true:
					selected = false
					interface.deselect_modification()
					color = Color(0.1, 0.1, 0.1)
				false:
					selected = true
					interface.select_modification(self)
					color = Color(0.6, 0.6, 0.2)

func unselect() -> void:
	selected = false
	color = Color(0.1, 0.1, 0.1)

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
