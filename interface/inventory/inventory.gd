extends Control
class_name Inventory

@onready var slots_container: GridContainer = $Background/SlotsContainer

func _ready() -> void:
	for i in slots_container.get_children():
		i.item_modified.connect(update_hotbar)
	if not Globals.world_data_dictionary.first_read:
		load_inventory()

func add_item(_item: Item) -> void:
	if _item.item_type == "consumable" or _item.item_type == "resource":
		for i in slots_container.get_children():
			if i.item != null and i.item.item_name == _item.item_name and i.item.item_amount < i.item.item_stack:
				i.update_amount("+", _item.item_amount)
				save_inventory()
				return
	for i in slots_container.get_children():
		if i.item == null:
			i.set_item(_item)
			save_inventory()
			return
	save_inventory()

func get_hotbar_items() -> Array:
	var a = []
	for i in range(0, 7):
		a.append(slots_container.get_child(i).item)
	return a

func _enter_tree() -> void:
	Globals.inventory = self

func get_item_amount(_item_name: String) -> int:
	var v = 0
	for i in slots_container.get_children():
		if i.item and i.item.item_name == _item_name:
			v += i.item.item_amount
	return v

func save_inventory() -> void:
	for i in range(0, slots_container.get_child_count()-1):
		var obj = slots_container.get_child(i)
		if obj.item != null:
			var aitem = obj.item.duplicate(true)
			aitem.item_amount = obj.item.item_amount
			Globals.world_data_dictionary.inventory_data[i] = aitem
			Globals.world_data_dictionary.inventory_data_amounts[i] = aitem.item_amount
	DataManagement.resave_world()

func load_inventory() -> void:
	var c = 0
	for i in slots_container.get_children():
		if Globals.world_data_dictionary.inventory_data[c] != null:
			var ait = Globals.world_data_dictionary.inventory_data[c].duplicate(true)
			ait.item_amount = Globals.world_data_dictionary.inventory_data_amounts[c]
			i.set_item(ait)
			print(ait.item_amount)
		c += 1

func update_hotbar() -> void:
	Globals.hotbar.update_items(get_hotbar_items())
