extends Control
class_name GunsBenchInterfaceComponent

@onready var camera: Camera3D = 
@onready var gun_damage_label: Label = $VBoxContainer/HBoxContainer/Label2
@onready var gun_fire_cadense_label: Label = $VBoxContainer/HBoxContainer2/Label2
@onready var gun_reload_time_label: Label = $VBoxContainer/HBoxContainer3/Label2
@onready var gun_max_ammo_label: Label = $VBoxContainer/HBoxContainer4/Label2
@onready var gun_recoil_label: Label = $VBoxContainer/HBoxContainer5/Label2
@onready var gun_precision_label: Label = $VBoxContainer/HBoxContainer6/Label2
@onready var gun_fire_range_label: Label = $VBoxContainer/HBoxContainer7/Label2

@onready var modifier_scene: PackedScene = preload("uid://jaf3rbsv30rw")
@onready var modifier_ingredient_scene: PackedScene = preload("uid://7es3whbhfdjl")

@onready var pipes_modifications_list: Array[GunModification] = [
	preload("res://modifiers/guns/debug_pipe_0.tres"),
	preload("res://modifiers/guns/debug_pipe_1.tres"),
	preload("res://modifiers/guns/debug_pipe_2.tres"),
	preload("res://modifiers/guns/debug_pipe_3.tres"),
	preload("res://modifiers/guns/debug_pipe_4.tres"),
	preload("res://modifiers/guns/debug_pipe_5.tres"),
	preload("res://modifiers/guns/debug_pipe_6.tres"),
	preload("res://modifiers/guns/debug_pipe_7.tres"),
	preload("res://modifiers/guns/debug_pipe_8.tres")
]
@onready var butts_modifications_list: Array[GunModification] = [
	preload("res://modifiers/guns/debug_butt_0.tres"),
	preload("res://modifiers/guns/debug_butt_1.tres"),
	preload("res://modifiers/guns/debug_butt_2.tres"),
	preload("res://modifiers/guns/debug_butt_3.tres"),
	preload("res://modifiers/guns/debug_butt_4.tres"),
	preload("res://modifiers/guns/debug_butt_5.tres"),
	preload("res://modifiers/guns/debug_butt_6.tres")
]
@onready var handles_modifications_list: Array[GunModification] = [
	preload("res://modifiers/guns/debug_handle_0.tres"),
	preload("res://modifiers/guns/debug_handle_1.tres"),
	preload("res://modifiers/guns/debug_handle_2.tres"),
	preload("res://modifiers/guns/debug_handle_3.tres"),
	preload("res://modifiers/guns/debug_handle_4.tres"),
	preload("res://modifiers/guns/debug_handle_5.tres")
]
@onready var scopes_modifications_list: Array[GunModification] = [
	preload("res://modifiers/guns/debug_scope_0.tres"),
	preload("res://modifiers/guns/debug_scope_1.tres"),
	preload("res://modifiers/guns/debug_scope_2.tres"),
	preload("res://modifiers/guns/debug_scope_3.tres"),
	preload("res://modifiers/guns/debug_scope_4.tres"),
	preload("res://modifiers/guns/debug_scope_5.tres")
]

@export var core_snap: Marker3D = null
@export var pipe_snap: Marker3D = null
@export var butt_snap: Marker3D = null
@export var handle_snap: Marker3D = null
@export var scope_snap: Marker3D = null

var gun_core: GunCore = null

var selected_modification: ModificationRecipe = null
var modification_ingredients: Array[CraftIngredient] = []

var on_handle: bool = false
var on_scope: bool = false
var on_pipe: bool = false
var on_butt: bool = false

var item: Item = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.global_position.y += (event.relative.y * 0.0001)
		camera.global_position.x += (event.relative.x * 0.0001)
		camera.global_position.x = clamp(camera.global_position.x, core_snap.global_position.x - 0.03, core_snap.global_position.x + 0.03)
		camera.global_position.y = clamp(camera.global_position.y, core_snap.global_position.y - 0.03, core_snap.global_position.y + 0.03)

func update_stats_table():
	gun_damage_label.text = str(gun_core.damage)
	gun_fire_cadense_label.text = str(gun_core.fire_cadense)
	gun_reload_time_label.text = str(gun_core.reload_time)
	gun_max_ammo_label.text = str(gun_core.max_ammo)
	gun_recoil_label.text = str(gun_core.recoil)
	gun_precision_label.text = str(gun_core.precision)
	gun_fire_range_label.text = str(gun_core.fire_range)

func update_stats_preview():
	if on_butt:
		var butt: GunButt = butt_snap.get_child(0)
		$VBoxContainer/HBoxContainer5/Label3.visible = true
		$VBoxContainer/HBoxContainer5/Label4.visible = true
		$VBoxContainer/HBoxContainer6/Label3.visible = true
		$VBoxContainer/HBoxContainer6/Label4.visible = true
		if butt.recoil >= 0:
			$VBoxContainer/HBoxContainer5/Label4.text = str(butt.recoil)
			$VBoxContainer/HBoxContainer5/Label3.text = "+"
			$VBoxContainer/HBoxContainer5/Label3.modulate = Color(1.0, 0.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer5/Label4.modulate = Color(1.0, 0.0, 0.0, 1.0)
		else:
			$VBoxContainer/HBoxContainer5/Label4.text = str(butt.recoil * -1)
			$VBoxContainer/HBoxContainer5/Label3.text = "-"
			$VBoxContainer/HBoxContainer5/Label3.modulate = Color(0.0, 1.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer5/Label4.modulate = Color(0.0, 1.0, 0.0, 1.0)
		if butt.precision >= 0:
			$VBoxContainer/HBoxContainer6/Label4.text = str(butt.precision)
			$VBoxContainer/HBoxContainer6/Label3.text = "+"
			$VBoxContainer/HBoxContainer6/Label3.modulate = Color(0.0, 1.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer6/Label4.modulate = Color(0.0, 1.0, 0.0, 1.0)
		else:
			$VBoxContainer/HBoxContainer6/Label4.text = str(butt.precision * -1)
			$VBoxContainer/HBoxContainer6/Label3.text = "-"
			$VBoxContainer/HBoxContainer6/Label3.modulate = Color(1.0, 0.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer6/Label4.modulate = Color(1.0, 0.0, 0.0, 1.0)
	elif on_handle:
		var handle: GunHandle = handle_snap.get_child(0)
		$VBoxContainer/HBoxContainer5/Label3.visible = true
		$VBoxContainer/HBoxContainer5/Label4.visible = true
		$VBoxContainer/HBoxContainer6/Label3.visible = true
		$VBoxContainer/HBoxContainer6/Label4.visible = true
		if handle.recoil >= 0:
			$VBoxContainer/HBoxContainer5/Label4.text = str(handle.recoil)
			$VBoxContainer/HBoxContainer5/Label3.text = "+"
			$VBoxContainer/HBoxContainer5/Label3.modulate = Color(1.0, 0.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer5/Label4.modulate = Color(1.0, 0.0, 0.0, 1.0)
		else:
			$VBoxContainer/HBoxContainer5/Label4.text = str(handle.recoil * -1)
			$VBoxContainer/HBoxContainer5/Label3.text = "-"
			$VBoxContainer/HBoxContainer5/Label3.modulate = Color(0.0, 1.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer5/Label4.modulate = Color(0.0, 1.0, 0.0, 1.0)
		if handle.precision >= 0:
			$VBoxContainer/HBoxContainer6/Label4.text = str(handle.precision)
			$VBoxContainer/HBoxContainer6/Label3.text = "+"
			$VBoxContainer/HBoxContainer6/Label3.modulate = Color(0.0, 1.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer6/Label4.modulate = Color(0.0, 1.0, 0.0, 1.0)
		else:
			$VBoxContainer/HBoxContainer6/Label4.text = str(handle.precision * -1)
			$VBoxContainer/HBoxContainer6/Label3.text = "-"
			$VBoxContainer/HBoxContainer6/Label3.modulate = Color(1.0, 0.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer6/Label4.modulate = Color(1.0, 0.0, 0.0, 1.0)
	elif on_scope:
		var scope: GunScope = scope_snap.get_child(0)
		$VBoxContainer/HBoxContainer6/Label3.visible = true
		$VBoxContainer/HBoxContainer6/Label4.visible = true
		if scope.precision >= 0:
			$VBoxContainer/HBoxContainer6/Label4.text = str(scope.precision)
			$VBoxContainer/HBoxContainer6/Label3.text = "+"
			$VBoxContainer/HBoxContainer6/Label3.modulate = Color(0.0, 1.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer6/Label4.modulate = Color(0.0, 1.0, 0.0, 1.0)
		else:
			$VBoxContainer/HBoxContainer6/Label4.text = str(scope.precision * -1)
			$VBoxContainer/HBoxContainer6/Label3.text = "-"
			$VBoxContainer/HBoxContainer6/Label3.modulate = Color(1.0, 0.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer6/Label4.modulate = Color(1.0, 0.0, 0.0, 1.0)
	elif on_pipe:
		var scope: GunPipe = pipe_snap.get_child(0)
		$VBoxContainer/HBoxContainer6/Label3.visible = true
		$VBoxContainer/HBoxContainer7/Label3.visible = true
		$VBoxContainer/HBoxContainer6/Label4.visible = true
		$VBoxContainer/HBoxContainer7/Label4.visible = true
		if scope.precision >= 0:
			$VBoxContainer/HBoxContainer6/Label4.text = str(scope.precision)
			$VBoxContainer/HBoxContainer6/Label3.text = "+"
			$VBoxContainer/HBoxContainer6/Label3.modulate = Color(0.0, 1.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer6/Label4.modulate = Color(0.0, 1.0, 0.0, 1.0)
		else:
			$VBoxContainer/HBoxContainer6/Label4.text = str(scope.precision * -1)
			$VBoxContainer/HBoxContainer6/Label3.text = "-"
			$VBoxContainer/HBoxContainer6/Label3.modulate = Color(1.0, 0.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer6/Label4.modulate = Color(1.0, 0.0, 0.0, 1.0)
		if scope.fire_range >= 0:
			$VBoxContainer/HBoxContainer7/Label4.text = str(scope.fire_range)
			$VBoxContainer/HBoxContainer7/Label3.text = "+"
			$VBoxContainer/HBoxContainer7/Label3.modulate = Color(0.0, 1.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer7/Label4.modulate = Color(0.0, 1.0, 0.0, 1.0)
		else:
			$VBoxContainer/HBoxContainer7/Label4.text = str(scope.fire_range * -1)
			$VBoxContainer/HBoxContainer7/Label3.text = "-"
			$VBoxContainer/HBoxContainer7/Label3.modulate = Color(1.0, 0.0, 0.0, 1.0)
			$VBoxContainer/HBoxContainer7/Label4.modulate = Color(1.0, 0.0, 0.0, 1.0)
	else:
		$VBoxContainer/HBoxContainer6/Label3.visible = false
		$VBoxContainer/HBoxContainer7/Label3.visible = false
		$VBoxContainer/HBoxContainer6/Label4.visible = false
		$VBoxContainer/HBoxContainer7/Label4.visible = false
		$VBoxContainer/HBoxContainer5/Label4.visible = false
		$VBoxContainer/HBoxContainer5/Label4.visible = false

func clear_stats_preview():
	$VBoxContainer/HBoxContainer6/Label3.visible = false
	$VBoxContainer/HBoxContainer7/Label3.visible = false
	$VBoxContainer/HBoxContainer6/Label4.visible = false
	$VBoxContainer/HBoxContainer7/Label4.visible = false
	$VBoxContainer/HBoxContainer5/Label3.visible = false
	$VBoxContainer/HBoxContainer5/Label4.visible = false

func init_camera_atributes():
	camera.global_position = $SubViewportContainer/SubViewport/Node3D/Node3D/CoreSnap.global_position + Vector3(0, 0, 1.6)

func _on_texture_button_2_button_up() -> void:
	if on_scope:
		$Panel2.visible = false
		hide_mods()
		deselect_modification()
		on_butt = false
		on_pipe = false
		on_handle = false
		on_scope = false
		clear_preview()
	else:
		$Panel2.visible = true
		set_mods_to_scopes()
		on_scope = true
		on_butt = false
		on_pipe = false
		on_handle = false
		clear_preview()

func set_item(_item: Item):
	item = _item
	update_core()

func _on_texture_button_3_button_up() -> void:
	if on_butt:
		$Panel2.visible = false
		hide_mods()
		deselect_modification()
		on_butt = false
		on_pipe = false
		on_handle = false
		on_scope = false
		clear_preview()
	else:
		$Panel2.visible = true
		set_mods_to_butts()
		on_butt = true
		on_pipe = false
		on_handle = false
		on_scope = false
		clear_preview()

func deselect_modification():
	clear_preview()
	$Panel3/VBoxContainer/HBoxContainer/Label2.text = ""
	for i in $Panel3/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	$Panel3.hide()
	
func _on_texture_button_4_button_up() -> void:
	if on_handle:
		$Panel2.visible = false
		hide_mods()
		deselect_modification()
		on_butt = false
		on_pipe = false
		on_handle = false
		on_scope = false
		clear_preview()
	else:
		$Panel2.visible = true
		set_mods_to_handles()
		on_butt = false
		on_pipe = false
		on_handle = true
		on_scope = false
		clear_preview()
	
func _on_texture_button_5_button_up() -> void:
	pass

func set_mods_to_pipes():
	for mod in $Panel2/ScrollContainer/VBoxContainer.get_children():
		mod.queue_free()
	for mod in pipes_modifications_list:
		var a = modifier_scene.instantiate()
		a.set_modification(mod.duplicate(true))
		a.interface = self
		$Panel2/ScrollContainer/VBoxContainer.add_child(a)

func set_mods_to_butts():
	for mod in $Panel2/ScrollContainer/VBoxContainer.get_children():
		mod.queue_free()
	for mod in butts_modifications_list:
		var a = modifier_scene.instantiate()
		a.set_modification(mod.duplicate(true))
		a.interface = self
		$Panel2/ScrollContainer/VBoxContainer.add_child(a)

func set_mods_to_handles():
	for mod in $Panel2/ScrollContainer/VBoxContainer.get_children():
		mod.queue_free()
	for mod in handles_modifications_list:
		var a = modifier_scene.instantiate()
		a.set_modification(mod.duplicate(true))
		a.interface = self
		$Panel2/ScrollContainer/VBoxContainer.add_child(a)

func set_mods_to_scopes():
	for mod in $Panel2/ScrollContainer/VBoxContainer.get_children():
		mod.queue_free()
	for mod in scopes_modifications_list:
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
	if selected_modification:
		if selected_modification != modification_recipe:
			selected_modification.unselect()
	selected_modification = modification_recipe
	set_preview(modification_recipe.item)
	modification_ingredients.clear()
	$Panel3.show()
	for i in $Panel3/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	$Panel3/VBoxContainer/HBoxContainer/Label2.text = modification_recipe.item.modification_name.to_snake_case().replace("_", " ").capitalize()
	for i in $Panel3/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for ingredient in modification_recipe.item.modification_ingredients:
		var b = modifier_ingredient_scene.instantiate()
		var aitem = ingredient.duplicate(true)
		aitem.item_amount = modification_recipe.item.modification_ingredients[ingredient]
		b.set_item(aitem)
		modification_ingredients.append(b)
		$Panel3/VBoxContainer/ScrollContainer/VBoxContainer.add_child(b)
	can_apply_modification()

func can_apply_modification():
	if Globals.inventory:
		var can_craft_itens = 0
		for ingredient in modification_ingredients:
			if ingredient.can_craft:
				can_craft_itens += 1
		if can_craft_itens == modification_ingredients.size():
			$Panel3/Modify.disabled = false
		else:
			$Panel3/Modify.disabled = true
	else:
		$Panel3/Modify.disabled = false

func set_preview(modification: GunModification):
	if on_butt:
		for i in gun_core.get_node("ComponentsSnaps/ButtSnap").get_children():
			i.visible = false
	if on_pipe:
		for i in gun_core.get_node("ComponentsSnaps/PipeSnap").get_children():
			i.visible = false
	if on_handle:
		for i in gun_core.get_node("ComponentsSnaps/HandleSnap").get_children():
			i.visible = false
	if on_scope:
		for i in gun_core.get_node("ComponentsSnaps/ScopeSnap").get_children():
			i.visible = false
	for i in pipe_snap.get_children():
		i.queue_free()
	for i in butt_snap.get_children():
		i.queue_free()
	for i in handle_snap.get_children():
		i.queue_free()
	for i in scope_snap.get_children():
		i.queue_free()
	var a = modification.modification_scene.instantiate()
	for i in a.get_children():
		if i is MeshInstance3D:
			i.material_override = load("res://materials/preview_material.tres")
			i.transparency = 0.3
	match modification.modification_type:
		"pipe":
			pipe_snap.add_child(a)
		"butt":
			butt_snap.add_child(a)
		"handle":
			handle_snap.add_child(a)
		"scope":
			scope_snap.add_child(a)
	update_stats_preview()

func clear_preview():
	if on_butt:
		for i in gun_core.get_node("ComponentsSnaps/ButtSnap").get_children():
			i.visible = true
	if on_pipe:
		for i in gun_core.get_node("ComponentsSnaps/PipeSnap").get_children():
			i.visible = true
	if on_handle:
		for i in gun_core.get_node("ComponentsSnaps/HandleSnap").get_children():
			i.visible = true
	if on_scope:
		for i in gun_core.get_node("ComponentsSnaps/ScopeSnap").get_children():
			i.visible = true
	for i in pipe_snap.get_children():
		i.queue_free()
	for i in butt_snap.get_children():
		i.queue_free()
	for i in handle_snap.get_children():
		i.queue_free()
	for i in scope_snap.get_children():
		i.queue_free()
	clear_stats_preview()

func update_core():
	for i in core_snap.get_children():
		i.queue_free()
	
	if item:
		var core = item.item_scene.instantiate()
		core.in_bench = true
		core.modifications = item.modifications
		core_snap.add_child(core)
		gun_core = core
	
		pipe_snap.global_position = core.get_node("ComponentsSnaps/PipeSnap").global_position
		butt_snap.global_position = core.get_node("ComponentsSnaps/ButtSnap").global_position
		handle_snap.global_position = core.get_node("ComponentsSnaps/HandleSnap").global_position
		scope_snap.global_position = core.get_node("ComponentsSnaps/ScopeSnap").global_position
		
		update_stats_table()
		clear_preview()

func _on_modify_button_up() -> void:
	var new_item: Item = item.duplicate(true)
	if on_pipe:
		new_item.modifications["pipe"] = selected_modification.item
	if on_butt:
		new_item.modifications["butt"] = selected_modification.item
	if on_handle:
		new_item.modifications["handle"] = selected_modification.item
	if on_scope:
		new_item.modifications["scope"] = selected_modification.item
	var old_name = new_item.item_name
	new_item.item_name = "Modified" + old_name
	$GunSlot.set_item(new_item)
	update_core()
	hide_mods()
	clear_stats_preview()
	update_stats_table()
	$Panel3/Modify.disabled = true

func clear_gun_data():
	$Panel2.visible = false
	$Panel3.visible = false
	$VBoxContainer.visible = false
	$TextureButton4.disabled = true
	$TextureButton3.disabled = true
	$TextureButton2.disabled = true
	$TextureButton.disabled = true
	item = null
	selected_modification = null
	
	clear_preview()
	clear_stats_preview()
	
	for i in core_snap.get_children():
		i.queue_free()

func show_gun_data():
	$VBoxContainer.visible = true
	$TextureButton4.disabled = false
	$TextureButton3.disabled = false
	$TextureButton2.disabled = false
	$TextureButton.disabled = false

func _on_texture_button_button_up() -> void:
	if on_pipe:
		$Panel2.visible = false
		hide_mods()
		deselect_modification()
		on_pipe = false
		on_handle = false
		on_scope = false
		on_butt = false
		clear_preview()
	else:
		$Panel2.visible = true
		set_mods_to_pipes()
		on_pipe = true
		on_handle = false
		on_scope = false
		on_butt = false
		clear_preview()
