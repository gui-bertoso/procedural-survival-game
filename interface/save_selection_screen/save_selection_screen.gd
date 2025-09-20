extends Control

var first_names_list = [
	"The",
	"A",
	""
]
var second_names_list = [
	"Beaultiful",
	"Good",
	"Greatest",
	"Normal",
	"Focus",
	""
]
var third_names_list = [
	"Map",
	"Place",
	"Greatest",
	"Ville",
	"Mountain",
]

var _selected_save_index = -1

func _ready() -> void:
	$Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveName/TextEdit.text = _randomize_save_name()
	$Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveSeed/TextEdit.text = str(_randomize_save_seed())
	_update_saves_list()

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_create_save_button_up() -> void:
	$Panel/HBoxContainer/SaveCreation.show()
	$CreateSave.disabled = true


func _on_create_button_up() -> void:
	DataManagement.world_save("res://" + "saves/" + $Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveName/TextEdit.text + ".txt")
	Globals.game_data_dictionary.saves.append($Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveName/TextEdit.text)
	$Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveName/TextEdit.text = _randomize_save_name()
	$Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveSeed/TextEdit.text = str(_randomize_save_seed())
	$Panel/HBoxContainer/SaveCreation.hide()
	$CreateSave.disabled = false
	DataManagement.load_world_save(DataManagement.current_save)
	DataManagement.save_game_save()
	_update_saves_list()

func _on_randomize_button_up() -> void:
	$Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveName/TextEdit.text = _randomize_save_name()
	$Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveSeed/TextEdit.text = str(_randomize_save_seed())


func _on_cancel_button_up() -> void:
	$Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveName/TextEdit.text = _randomize_save_name()
	$Panel/HBoxContainer/SaveCreation/VBoxContainer/SaveSeed/TextEdit.text = str(_randomize_save_seed())
	$Panel/HBoxContainer/SaveCreation.hide()
	$CreateSave.disabled = false

func _randomize_save_name() -> String:
	var _name = ""
	
	var _index_0 = randi_range(0, first_names_list.size()-1)
	var _index_1 = randi_range(0, second_names_list.size()-1)
	var _index_2 = randi_range(0, third_names_list.size()-1)
	
	_name = first_names_list[_index_0] + second_names_list[_index_1] + third_names_list[_index_2]
	
	return _name

func _randomize_save_seed() -> int:
	var _seed = randi_range(0, 99999999999999999)
	return _seed

func _update_saves_list() -> void:
	$Panel/HBoxContainer/SavesSelector/HBoxContainer/ItemList.clear()
	var saves_list = Globals.game_data_dictionary.saves
	for save in saves_list:
		$Panel/HBoxContainer/SavesSelector/HBoxContainer/ItemList.add_item(save)


func _on_play_save_button_up() -> void:
	DataManagement.load_world_save("res://" + "save/" + $Panel/HBoxContainer/SavesSelector/HBoxContainer/ItemList.get_item_text(_selected_save_index) + ".txt")
	get_tree().change_scene_to_file("res://map/main.tscn")

func _on_item_list_item_selected(index: int) -> void:
	$PlaySave.disabled = false
	_selected_save_index = index
	DataManagement.current_save = $Panel/HBoxContainer/SavesSelector/HBoxContainer/ItemList.get_item_text(_selected_save_index)
	$DeleteSave.disabled = false

func _on_delete_save_button_up() -> void:
	DirAccess.remove_absolute("res://" + "save/" + DataManagement.current_save + ".txt")
	Globals.game_data_dictionary.saves.erase(DataManagement.current_save)
	DataManagement.current_save = ""
	$Panel/HBoxContainer/SavesSelector/HBoxContainer/ItemList.deselect(_selected_save_index)
	_selected_save_index = -1
	_update_saves_list()
	DataManagement.save_game_save()
	$DeleteSave.disabled = true
