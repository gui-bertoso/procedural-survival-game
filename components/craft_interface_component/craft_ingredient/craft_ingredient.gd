extends ColorRect
class_name CraftIngredient

@onready var _item_texture: TextureRect = $HBoxContainer/TextureRect
@onready var _item_name_label: Label = $HBoxContainer/Label
@onready var _item_amount_label: Label = $HBoxContainer/Label2
@onready var _item_amount_sufix_label: Label = $HBoxContainer/Label3

var can_craft: bool = false

var item: Item = null

func set_item(_item: Item) -> void:
	item = _item.duplicate(true)
	item.item_amount = _item.item_amount
	_item_texture.texture = item.item_image
	_item_name_label.text = item.item_name.to_snake_case().replace("_", " ").capitalize()
	_item_amount_label.text = str(item.item_amount)
	update_can_craft()

func update_can_craft() -> void:
	if not Globals.inventory:
		_item_amount_label.modulate = Color(1, 1, 0)
		_item_amount_sufix_label.modulate = Color(1, 1, 0)
		can_craft = true
		return
	if Globals.inventory.get_item_amount(item.item_name) >= item.item_amount:
		_item_amount_label.modulate = Color(0, 1, 0)
		_item_amount_sufix_label.modulate = Color(0, 1, 0)
		can_craft = true
	else:
		_item_amount_label.modulate = Color(1, 0, 0)
		_item_amount_sufix_label.modulate = Color(1, 0, 0)
		can_craft = false
