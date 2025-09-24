extends Control
class_name CraftInterfaceComponent

@onready var _recipes_container: VBoxContainer = $HContainer/Background/ScrollContainer/RecipesContainer
@onready var _ingredients_container: VBoxContainer = $HContainer/Background2/VContainer/ScrollContainer/IngredientsContainer
@onready var _craft_menu: ColorRect = $HContainer/CraftMenu
@onready var _craft_button: Button = $HContainer/CraftMenu/VContainer/CraftButton
@onready var _craft_name_label: Label = $HContainer/CraftMenu/VContainer/CraftName
@onready var _craft_type_label: Label = $HContainer/CraftMenu/VContainer/CraftType/Value
@onready var _craft_quantity_label: Label = $HContainer/CraftMenu/VContainer/CraftQuantity/Value

@onready var craft_recipe_scene: PackedScene = preload("uid://4t4hdhigv82e")
@onready var craft_ingredient_scene: PackedScene = preload("uid://d3cf6gb4ldt7y")

@export var crafts: Array[Item] = []

var selected_recipe: CraftRecipe = null

func load_recipes() -> void:
	for i in _recipes_container.get_children():
		i.queue_free()
	for i in crafts:
		var a = craft_recipe_scene.instantiate()
		a.set_item(i)
		a.craft_interface = self
		_recipes_container.add_child(a)

func unselect_recipe() -> void:
	for i in _ingredients_container.get_children():
		i.queue_free()
	_craft_menu.visible = false

func select_recipe(recipe: CraftRecipe) -> void:
	_craft_menu.visible = true
	if selected_recipe != null and selected_recipe.item != recipe.item:
		selected_recipe.unselect()
	selected_recipe = recipe
	for i in _ingredients_container.get_children():
		i.queue_free()
	for i in selected_recipe.item.item_craft_recipe:
		var a = craft_ingredient_scene.instantiate()
		var ie = i.duplicate(true)
		ie.item_amount = selected_recipe.item.item_craft_recipe[i]
		a.set_item(ie)
		_ingredients_container.add_child(a)
	_craft_name_label.text = selected_recipe.item.item_name.to_snake_case().replace("_", " ").capitalize()
	_craft_type_label.text = selected_recipe.item.item_type.to_upper()
	_craft_quantity_label.text = str(selected_recipe.item.item_craft_quantity)
	can_craft()

func can_craft() -> void:
	var can_craft_ingredients = 0
	for i in _ingredients_container.get_children():
		if i.can_craft:
			can_craft_ingredients += 1
	if can_craft_ingredients >= selected_recipe.item.item_craft_recipe.size():
		_craft_button.disabled = false
	else:
		_craft_button.disabled = true

func _on_button_button_up() -> void:
	var new_item: Item = selected_recipe.item.duplicate(true)
	new_item.item_amount = selected_recipe.item.item_amount
	if Globals.inventory:
		Globals.inventory.add_item(new_item)
	_craft_menu.visible = false
	selected_recipe.unselect()
	selected_recipe = null
	_craft_button.disabled = true
