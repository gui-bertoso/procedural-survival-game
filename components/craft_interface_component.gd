extends Control
class_name CraftInterfaceComponent

@export var crafts: Array[Item] = []

var selected_recipe = null

func load_recipes() -> void:
	for i in $HBoxContainer/ColorRect/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in crafts:
		var a = load("res://components/craft_recipe.tscn").instantiate()
		a.set_item(i)
		a.craft_interface = self
		$HBoxContainer/ColorRect/ScrollContainer/VBoxContainer.add_child(a)

func unselect_recipe():
	for i in $HBoxContainer/ColorRect2/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	$HBoxContainer/ColorRect2.visible = false

func select_recipe(recipe: CraftRecipe):
	$HBoxContainer/ColorRect2.visible = true
	selected_recipe = recipe
	for i in $HBoxContainer/ColorRect2/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in selected_recipe.item.item_craft_recipe:
		var a = load("res://components/craft_ingredient.tscn").instantiate()
		var ie = i.duplicate(true)
		ie.item_amount = selected_recipe.item.item_craft_recipe[i]
		print(ie.item_amount)
		a.set_item(ie)
		$HBoxContainer/ColorRect2/VBoxContainer/ScrollContainer/VBoxContainer.add_child(a)
	$HBoxContainer/ColorRect2/VBoxContainer/Label.text = selected_recipe.item.item_name.to_snake_case().replace("_", " ").capitalize()
	$HBoxContainer/ColorRect2/VBoxContainer/HBoxContainer/Label4.text = selected_recipe.item.item_type.to_upper()
	$HBoxContainer/ColorRect2/VBoxContainer/HBoxContainer2/Label4.text = str(selected_recipe.item.item_craft_quantity)
	
