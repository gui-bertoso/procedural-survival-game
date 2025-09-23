extends Control
class_name Hotbar

func _enter_tree() -> void:
	Globals.hotbar = self

func update_items(items_array: Array):
	var c = 0
	for i in $HBoxContainer.get_child_count():
		if items_array[c] != null:
			$HBoxContainer.get_child(c).set_item(items_array[c])
		else:
			$HBoxContainer.get_child(c).clear_item()
		c += 1
