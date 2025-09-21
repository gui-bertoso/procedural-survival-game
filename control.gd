extends Control
class_name GunsBench

@onready var core_snap = $SubViewportContainer/SubViewport/Node3D/Node3D/CoreSnap
@onready var modifier_scene = preload("res://interface/modifiers/modifier_container.tscn")

var gun_core = null

var core_index = 0
var pipe_index = 0
var butt_index = 0

var pipes_mod_list = [
	preload("res://modifications/guns/debug_pipe_0.tres"),
	preload("res://modifications/guns/debug_pipe_1.tres"),
	preload("res://modifications/guns/debug_pipe_2.tres"),
	preload("res://modifications/guns/debug_pipe_3.tres"),
	preload("res://modifications/guns/debug_pipe_4.tres"),
	preload("res://modifications/guns/debug_pipe_5.tres"),
	preload("res://modifications/guns/debug_pipe_6.tres"),
	preload("res://modifications/guns/debug_pipe_7.tres"),
	preload("res://modifications/guns/debug_pipe_8.tres")
]
var butts_mod_list = [
	preload("res://modifications/guns/debug_butt_0.tres"),
	preload("res://modifications/guns/debug_butt_1.tres"),
	preload("res://modifications/guns/debug_butt_2.tres"),
	preload("res://modifications/guns/debug_butt_3.tres"),
	preload("res://modifications/guns/debug_butt_4.tres"),
	preload("res://modifications/guns/debug_butt_5.tres"),
	preload("res://modifications/guns/debug_butt_6.tres")
]

var cores_list = [
	preload("res://weapons/guns/gun_core/gun_core_0.tscn"),
	preload("res://weapons/guns/gun_core/gun_core_1.tscn"),
	preload("res://weapons/guns/gun_core/gun_core_2.tscn"),
	preload("res://weapons/guns/gun_core/gun_core_3.tscn")
]

var selected_modification = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$SubViewportContainer/SubViewport/Node3D/Camera3D.global_position.y += (event.relative.y * 0.0001)
		$SubViewportContainer/SubViewport/Node3D/Camera3D.global_position.x += (event.relative.x * 0.0001)

var on_pipe = false
func _on_texture_button_button_up() -> void:
	if on_pipe:
		$Panel2.visible = false
		hide_mods()
		deselect_modification()
		on_pipe = false
		on_butt = false
	else:
		$Panel2.visible = true
		set_mods_to_pipes()
		on_pipe = true
		on_butt = false

func _on_texture_button_2_button_up() -> void:
	pass

var on_butt = false
func _on_texture_button_3_button_up() -> void:
	if on_butt:
		$Panel2.visible = false
		hide_mods()
		deselect_modification()
		on_butt = false
		on_pipe = false
	else:
		$Panel2.visible = true
		set_mods_to_butts()
		on_butt = true
		on_pipe = false

func deselect_modification():
	$Panel3/VBoxContainer/HBoxContainer/Label2.text = ""
	for i in $Panel3/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	$Panel3.hide()
	
func _on_texture_button_4_button_up() -> void:
	pass
	
func _on_texture_button_5_button_up() -> void:
	pass

func _ready() -> void:
	update_core()

func set_mods_to_pipes():
	for mod in $Panel2/ScrollContainer/VBoxContainer.get_children():
		mod.queue_free()
	for mod in pipes_mod_list:
		var a = modifier_scene.instantiate()
		a.set_modification(mod.duplicate(true))
		a.interface = self
		$Panel2/ScrollContainer/VBoxContainer.add_child(a)

func set_mods_to_butts():
	for mod in $Panel2/ScrollContainer/VBoxContainer.get_children():
		mod.queue_free()
	for mod in butts_mod_list:
		var a = modifier_scene.instantiate()
		a.set_modification(mod.duplicate(true))
		a.interface = self
		$Panel2/ScrollContainer/VBoxContainer.add_child(a)


func hide_mods():
	for mod in $Panel2/ScrollContainer/VBoxContainer.get_children():
		mod.queue_free()
	$Panel2.hide()
	$Panel3.hide()

func select_modification(modification_recipe: ModificationRecipe):
	selected_modification = modification_recipe
	$Panel3.show()
	for i in $Panel3/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	$Panel3/VBoxContainer/HBoxContainer/Label2.text = modification_recipe.item.modification_name.to_snake_case().replace("_", " ").capitalize()
	for i in $Panel3/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for ingredient in modification_recipe.item.modification_ingredients:
		var b = preload("res://interface/modifiers/modifier_ingredient.tscn").instantiate()
		var item = ingredient.duplicate(true)
		item.item_amount = modification_recipe.item.modification_ingredients[ingredient]
		b.set_item(item)
		$Panel3/VBoxContainer/ScrollContainer/VBoxContainer.add_child(b)

func update_core():
	for i in core_snap.get_children():
		i.queue_free()
	
	var core = cores_list[core_index].instantiate()
	core.name = "GunCore"
	core.in_bench = true
	core_snap.add_child(core)
	gun_core = core

func _on_button_2_button_up() -> void:
	pass
