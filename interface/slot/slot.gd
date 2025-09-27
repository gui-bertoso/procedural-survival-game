extends Control
class_name Slot

@export var item_texture: TextureRect = null
@export var item_amount_label: Label = null
@export var item_durability_bar: TextureProgressBar = null
@export var item_modified_indicator: TextureRect = null

signal item_modified

var item: Item = null

func set_item(_item: Item) -> void:
	item = _item.duplicate(true)
	item.item_amount = _item.item_amount
	item_texture.texture = item.item_image
	if item.item_type == "weapon" or item.item_type == "equipable":
		item_durability_bar.max_value = item.item_durability
		item_durability_bar.value = item.item_current_durability
		item_durability_bar.show()
		if item.modifications != {}:
			item_modified_indicator.show()
	elif item.item_type == "consumable" or item.item_type == "resource":
		item_amount_label.text = str(item.item_amount)
		item_amount_label.show()
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
		item_amount_label.text = str(item.item_amount)
	else:
		item.item_amount -= value
		item_amount_label.text = str(item.item_amount)

func clear_item() -> void:
	item = null
	item_texture.texture = null
	item_amount_label.text = ""
	item_durability_bar.value = 0
	item_durability_bar.hide()
	item_amount_label.hide()
	item_modified_indicator.hide()
	item_modified.emit()

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Array and data[0] is Item and data[1] != self:
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if item != null:
		if item.item_name == data[0].item_name:
			if item.item_amount < item.item_stack:
				update_amount("+", data[0].item_amount)
				data[1].clear_item()
				return
	set_item(data[0])
	if data[2]:
		data[1].clear_item()

func _get_drag_data(_at_position: Vector2) -> Variant:
	if item != null:
		if Input.is_action_pressed("divide_item_drag") and item.item_amount > 1:
			var _a: Control = Control.new()
			var _b: TextureRect = TextureRect.new()
			_b.texture = item_texture.texture
			_a.add_child(_b)
			set_drag_preview(_a)
			var _item_copy: Item = item.duplicate(true)
			_item_copy.item_amount = roundi(item.item_amount * 0.5)
			update_amount("-", _item_copy.item_amount)
			return [_item_copy, self, false]
		var a = Control.new()
		var b = TextureRect.new()
		b.texture = item_texture.texture
		a.add_child(b)
		set_drag_preview(a)
		var item_copy = item.duplicate(true)
		item_copy.item_amount = item.item_amount
		return [item_copy, self, true]
	return null
