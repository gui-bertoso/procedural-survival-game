extends TextureRect
class_name BenchGunSlot

var item: Item = null

func _ready() -> void:
	set_item(load("res://itens/gun_core_1.tres"))

func set_item(_item: Item) -> void:
	item = _item.duplicate(true)
	$ItemImage.texture = item.item_image
	if Globals.inventory:
		Globals.inventory.save_inventory()
	DataManagement.resave_world()
	get_parent().set_item(item)
	get_parent().show_gun_data()

func clear_item() -> void:
	item = null
	$ItemImage.texture = null
	get_parent().clear_gun_data()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is Array and data[0] is Item and data[1] != self:
		if data[0].item_type == "weapon" and data[0].weapon_type == "gun":
			return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if item != null:
		data[1].set_item(item.duplicate(true))
		set_item(data[0])
		return
	set_item(data[0])
	data[1].clear_item()

func _get_drag_data(at_position: Vector2) -> Variant:
	if item != null:
		var a = Control.new()
		var b = TextureRect.new()
		b.texture = $ItemImage.texture
		a.add_child(b)
		set_drag_preview(a)
		var item_copy = item.duplicate(true)
		return [item_copy, self, true]
	return null
