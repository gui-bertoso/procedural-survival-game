extends ColorRect
class_name ModifierIngredient

@onready var item_texture: TextureRect = $HContainer/ItemTexture
@onready var item_name: Label = $HContainer/ItemName
@onready var item_sufix: Label = $HContainer/Sufix
@onready var item_amount: Label = $HContainer/ItemAmount

var can_craft: bool = false

var item: Item = null

func set_item(_item: Item) -> void:
	item = _item.duplicate(true)
	item.item_amount = _item.item_amount
	item_texture.texture = item.item_image
	item_name.text = item.item_name.to_snake_case().replace("_", " ").capitalize()
	item_amount.text = str(item.item_amount)
	update_can_craft()

func update_can_craft() -> void:
	if not Globals.inventory:
		item_sufix.modulate = Color(1, 1, 0)
		item_amount.modulate = Color(1, 1, 0)
		return
	if Globals.inventory.get_item_amount(item.item_name) >= item.item_amount:
		item_sufix.modulate = Color(0, 1, 0)
		item_amount.modulate = Color(0, 1, 0)
		can_craft = true
	else:
		item_sufix.modulate = Color(1, 0, 0)
		item_amount.modulate = Color(1, 0, 0)
		can_craft = false
