extends Control
class_name Hotbar

@onready var slots_container: HBoxContainer = $HContainer
@onready var slot_outline: TextureRect = $SlotOutline

var outline_offset: Vector2 = Vector2(6, 6)

var current_slot_index: int = 0

var current_slot: Slot = null

func _enter_tree() -> void:
	Globals.hotbar = self

func _ready() -> void:
	current_slot_index = Globals.world_data_dictionary.current_hotbar_slot
	update_outline()

func _process(_delta: float) -> void:
	_slot_selectior_behavior()

func _slot_selectior_behavior() -> void:
	if Input.is_action_just_pressed("hotbar_slot_1"):
		current_slot_index = 0
		update_outline()
	if Input.is_action_just_pressed("hotbar_slot_2"):
		current_slot_index = 1
		update_outline()
	if Input.is_action_just_pressed("hotbar_slot_3"):
		current_slot_index = 2
		update_outline()
	if Input.is_action_just_pressed("hotbar_slot_4"):
		current_slot_index = 3
		update_outline()
	if Input.is_action_just_pressed("hotbar_slot_5"):
		current_slot_index = 4
		update_outline()
	if Input.is_action_just_pressed("hotbar_slot_6"):
		current_slot_index = 5
		update_outline()
	if Input.is_action_just_pressed("hotbar_slot_7"):
		current_slot_index = 6
		update_outline()
	
	if Input.is_action_just_pressed("left_hotbar_slot"):
		left_slot()
	if Input.is_action_just_pressed("next_hotbar_slot"):
		next_slot()

func update_outline() -> void:
	current_slot = slots_container.get_child(current_slot_index)
	slot_outline.global_position = current_slot.global_position - outline_offset
	if Globals.player_hand == null: return
	if current_slot.item != null:
		Globals.player_hand.set_item(current_slot.item)
	else:
		Globals.player_hand.clear_item()

func next_slot() -> void:
	current_slot_index += 1
	if current_slot_index > 6:
		current_slot_index = 6
	update_outline()
func left_slot() -> void:
	current_slot_index -= 1
	if current_slot_index < 0:
		current_slot_index = 0
	update_outline()

func update_items(items_array: Array) -> void:
	if not slots_container: return
	var c = 0
	for i in slots_container.get_child_count():
		if items_array[c] != null:
			slots_container.get_child(c).set_item(items_array[c])
		else:
			slots_container.get_child(c).clear_item()
		c += 1
