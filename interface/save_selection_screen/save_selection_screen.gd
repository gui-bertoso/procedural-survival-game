extends Control
class_name SaveSelectionScreen

@onready var save_name_editor: TextEdit = $Panel/HContainer/SaveCreation/VContainer/SaveName/TextEditor
@onready var save_seed_editor: TextEdit = $Panel/HContainer/SaveCreation/VContainer/SaveSeed/TextEditor
@onready var map_size_selector: OptionButton = $Panel/HContainer/SaveCreation/VContainer/MapSize/OptionButton
@onready var save_difficulty_selector: OptionButton = $Panel/HContainer/SaveCreation/VContainer/SaveDifficulty/OptionButton
@onready var saves_list: ItemList = $Panel/HContainer/SavesSelector/HContainer/SavesList

#Parei aqui de trabalhar


@onready var first_names_list: Array[String] = [
	"The",
	"A",
	"An",
	"My",
	"Our",
	""
]
@onready var second_names_list: Array[String] = [
	"Intelligent",
	"Creative",
	"Loyal",
	"Honest",
	"Kind",
	"Strong",
	"Brave",
	"Determined",
	"Charismatic",
	"Humble",
	"Generous",
	"Funny",
	"Responsible",
	"Patient",
	"Empathetic",
	"Organized",
	"Hardworking",
	"Fair",
	"Positive",
	"Resilient",
	
	"Lazy",
	"Arrogant",
	"Selfish",
	"Stubborn",
	"Impatient",
	"Gossiping",
	"Irresponsible",
	"Insecure",
	"Envious",
	"Cowardy",
	"Rude",
	"Manipulative",
	"Proud",
	"Dishonest",
	"Careless",
	"Pessimistic",
	"Jealous",
	"Stingy",
	"Fickle",
	"Bossy",
	
	""
]
@onready var third_names_list: Array[String] = [
	"Mountain",
	"Hill",
	"Valley",
	"River",
	"Lake",
	"Ocean",
	"Sea",
	"Desert",
	"Forest",
	"Jungle",
	"Swamp",
	"Canyon",
	"Cliff",
	"Volcano",
	"Glacier",
	"Island",
	"Coast",
	"Beach",
	"Cave",
	"Meadow",
	
	"Place",
	"Village",
	"Town",
	"City",
	"Capital",
	"Fortress",
	"Castle",
	"Temple",
	"Shrine",
	"Tower",
	"Dungeon",
	"Ruins",
	"Harbor",
	"Bridge",
	"Road",
	"Camp",
	"Market",
	"Square",
	"Inn",
	"Map"
]

var _selected_save_index: int = -1

func _ready() -> void:
	save_name_editor.text = _randomize_save_name()
	save_seed_editor.text = str(_randomize_save_seed())
	_update_saves_list()

func _randomize_save_name() -> String:
	var _name: String = ""
	
	var _index_0: int = randi_range(0, first_names_list.size()-1)
	var _index_1: int = randi_range(0, second_names_list.size()-1)
	var _index_2: int = randi_range(0, third_names_list.size()-1)
	
	_name = first_names_list[_index_0] + second_names_list[_index_1] + third_names_list[_index_2]
	
	return _name

func _randomize_save_seed() -> int:
	var _seed = randi_range(0, 99999999999999999)
	return _seed

func _update_saves_list() -> void:
	saves_list.clear()
	var saves_list = Globals.game_data_dictionary.saves
	for save in saves_list:
		saves_list.add_item(save)

func _on_item_list_item_selected(index: int) -> void:
	$PlaySave.disabled = false
	_selected_save_index = index
	DataManagement.current_save = $Panel/HBoxContainer/SavesSelector/HBoxContainer/ItemList.get_item_text(_selected_save_index)
	$DeleteSave.disabled = false

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

func _on_play_save_button_up() -> void:
	DataManagement.load_world_save("res://" + "save/" + $Panel/HBoxContainer/SavesSelector/HBoxContainer/ItemList.get_item_text(_selected_save_index) + ".txt")
	get_tree().change_scene_to_file("res://map/main.tscn")

func _on_delete_save_button_up() -> void:
	DirAccess.remove_absolute("res://" + "save/" + DataManagement.current_save + ".txt")
	Globals.game_data_dictionary.saves.erase(DataManagement.current_save)
	DataManagement.current_save = ""
	$Panel/HBoxContainer/SavesSelector/HBoxContainer/ItemList.deselect(_selected_save_index)
	_selected_save_index = -1
	_update_saves_list()
	DataManagement.save_game_save()
	$DeleteSave.disabled = true
