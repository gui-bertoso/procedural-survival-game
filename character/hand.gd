extends Marker3D
class_name PlayerHand

var current_item_class: String = ""

var item: Item = null

func _ready() -> void:
	Globals.player_hand = self

func set_item(_item: Item) -> void:
	item = _item.duplicate(true)
	item.item_amount = _item.item_amount
	
	if item.item_scene:
		var scene = item.item_scene.instantiate()
		if scene is GunCore:
			scene.modifications = item.modifications
		add_child(scene)
	else:
		add_child(item.item_mesh.instantiate())
	match_item_class()

func match_item_class() -> void:
	current_item_class = ""
	if item.weapon_type != "":
		current_item_class = item.weapon_type
	elif item.equipable_type != "":
		current_item_class = item.equipable_type
	else:
		current_item_class = item.item_type

func clear_item() -> void:
	for i in get_children():
		i.queue_free()
