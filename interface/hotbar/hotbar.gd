extends Control
class_name Hotbar

@onready var slots_container: HBoxContainer = $HContainer

func _enter_tree() -> void:
	Globals.hotbar = self

func update_items(items_array: Array) -> void:
	if not slots_container: return
	var c = 0
	for i in slots_container.get_child_count():
		if items_array[c] != null:
			slots_container.get_child(c).set_item(items_array[c])
		else:
			slots_container.get_child(c).clear_item()
		c += 1
