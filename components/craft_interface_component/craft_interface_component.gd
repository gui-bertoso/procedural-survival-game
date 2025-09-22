extends Control
class_name CraftInterfaceComponent

@onready var _recipes_container: VBoxContainer = $HBoxContainer/ColorRect/ScrollContainer/VBoxContainer

@onready var craft_recipe_scene: PackedScene = preload("uid://4t4hdhigv82e")

@export var crafts: Array[Item] = []

var selected_recipe: CraftRecipe = null

func load_recipes() -> void:
	for i in _recipes_container.get_children():
		i.queue_free()
	for i in crafts:
		var a = load("res://components/craft_recipe.tscn").instantiate()
		a.set_item(i)
		a.craft_interface = self
		$HBoxContainer/ColorRect/ScrollContainer/VBoxContainer.add_child(a)

func unselect_recipe() -> void:
	for i in $HBoxContainer/ColorRect2/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	$HBoxContainer/ColorRect2.visible = false

func select_recipe(recipe: CraftRecipe) -> void:
	$HBoxContainer/ColorRect2.visible = true
	if selected_recipe != null and selected_recipe.item != recipe.item:
		selected_recipe.unselect()
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
	can_craft()

func can_craft() -> void:
	var can_craft_ingredients = 0
	for i in $HBoxContainer/ColorRect2/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		if i.can_craft:
			can_craft_ingredients += 1
	if can_craft_ingredients >= selected_recipe.item.item_craft_recipe.size():
		$HBoxContainer/ColorRect2/VBoxContainer/Button.disabled = false
	else:
		$HBoxContainer/ColorRect2/VBoxContainer/Button.disabled = true

func _on_button_button_up() -> void:
	var new_item: Item = selected_recipe.item.duplicate(true)
	new_item.item_amount = selected_recipe.item.item_amount
	if Globals.inventory:
		Globals.inventory.add_item(new_item)
	$HBoxContainer/ColorRect2.visible = false
	selected_recipe.unselect()
	selected_recipe = null
	$HBoxContainer/ColorRect2/VBoxContainer/Button.disabled = true
