extends Control
class_name Slot

signal item_modified

var item: Item = null

func set_item(_item: Item) -> void:
	item = _item.duplicate(true)
	item.item_amount = _item.item_amount
	$ItemImage.texture = item.item_image
	if item.item_type == "weapon" or item.item_type == "equipable":
		$ItemDurability.max_value = item.item_durability
		$ItemDurability.value = item.item_current_durability
		$ItemDurability.show()
	elif item.item_type == "consumable" or item.item_type == "resource":
		$ItemAmount.text = str(item.item_amount)
		$ItemAmount.show()
	item_modified.emit()
	print("A: " + str(_item.item_amount))
	Globals.inventory.save_inventory()
	DataManagement.resave_world()

func update_amount(type: String, value: int) -> void:
	if type == "+":
		item.item_amount += value
		if item.item_amount > item.item_stack:
			var leftover = item.item_amount - item.item_stack
			item.item_amount = item.item_stack
			var new_item = item.duplicate(true)
			new_item.item_amount = leftover
			Globals.inventory.add_item(new_item)
		$ItemAmount.text = str(item.item_amount)
	else:
		item.item_amount -= value
		$ItemAmount.text = str(item.item_amount)

func clear_item() -> void:
	item = null
	$ItemImage.texture = null
	$ItemAmount.text = ""
	$ItemDurability.value = 0
	$ItemDurability.hide()
	$ItemAmount.hide()
	item_modified.emit()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is Array and data[0] is Item and data[1] != self:
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if item != null:
		if item.item_name == data[0].item_name:
			if item.item_amount < item.item_stack:
				update_amount("+", data[0].item_amount)
				data[1].clear_item()
				return
	set_item(data[0])
	if data[2]:
		data[1].clear_item()

func _get_drag_data(at_position: Vector2) -> Variant:
	if item != null:
		if Input.is_action_pressed("divide_item_drag") and item.item_amount > 1:
			var a = Control.new()
			var b = TextureRect.new()
			b.texture = $ItemImage.texture
			a.add_child(b)
			set_drag_preview(a)
			var item_copy = item.duplicate(true)
			item_copy.item_amount = int(item.item_amount/2)
			update_amount("-", item_copy.item_amount)
			print("A: " + str(item_copy.item_amount))
			return [item_copy, self, false]
		var a = Control.new()
		var b = TextureRect.new()
		b.texture = $ItemImage.texture
		a.add_child(b)
		set_drag_preview(a)
		var item_copy = item.duplicate(true)
		item_copy.item_amount = item.item_amount
		print("A: " + str(item_copy.item_amount))
		return [item_copy, self, true]
	return null
