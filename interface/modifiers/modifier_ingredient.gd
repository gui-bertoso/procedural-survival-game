extends ColorRect

var item = null

func set_item(_item):
	item = _item.duplicate(true)
	item.item_amount = _item.item_amount
	$HBoxContainer/TextureRect.texture = item.item_image
	$HBoxContainer/Label.text = item.item_name.to_snake_case().replace("_", " ").capitalize()
	$HBoxContainer/Label3.text = str(item.item_amount)
	update_can_craft()

func update_can_craft():
	if not Globals.inventory:
		$HBoxContainer/Label2.modulate = Color(1, 1, 0)
		$HBoxContainer/Label3.modulate = Color(1, 1, 0)
		return
	if Globals.inventory.get_item_amount(item.item_name) >= item.item_amount:
		$HBoxContainer/Label2.modulate = Color(0, 1, 0)
		$HBoxContainer/Label3.modulate = Color(0, 1, 0)
	else:
		$HBoxContainer/Label2.modulate = Color(1, 0, 0)
		$HBoxContainer/Label3.modulate = Color(1, 0, 0)
