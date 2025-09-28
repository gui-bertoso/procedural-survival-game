extends Control
class_name SaveSelectionScreen

@onready var main_menu_scene_path: String = "uid://crev2inf1u6xe"
@onready var default_map_scene_path: String = "uid://cgyrrwv1qx147"

@onready var save_name_editor: TextEdit = $Panel/HContainer/SaveCreation/VContainer/SaveName/TextEditor
@onready var save_seed_editor: TextEdit = $Panel/HContainer/SaveCreation/VContainer/SaveSeed/TextEditor
@onready var map_size_selector: OptionButton = $Panel/HContainer/SaveCreation/VContainer/MapSize/OptionButton
@onready var save_difficulty_selector: OptionButton = $Panel/HContainer/SaveCreation/VContainer/SaveDifficulty/OptionButton
@onready var saves_list: ItemList = $Panel/HContainer/SavesSelector/HContainer/SavesList

@onready var play_save_button: Button = $PlaySaveButton
@onready var create_save_button: Button = $Panel/HContainer/SaveCreation/ButtonsContainer/CreateButton
@onready var delete_save_button: Button = $DeleteSaveButton

@onready var save_creation_container: Panel = $Panel/HContainer/SaveCreation

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
	var saves_array = Globals.game_data_dictionary.saves
	for save in saves_array:
		saves_list.add_item(save)

func _on_item_list_item_selected(index: int) -> void:
	play_save_button.disabled = false
	_selected_save_index = index
	DataManagement.current_save = saves_list.get_item_text(_selected_save_index)
	delete_save_button.disabled = false

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file(main_menu_scene_path)

func _on_create_save_button_up() -> void:
	save_creation_container.show()
	create_save_button.disabled = false

func _on_create_button_up() -> void:
	Globals.world_data_dictionary.map_noise_seed = randi_range(0, 9999999999999999999999999999)
	Globals.world_data_dictionary.map_noise_frequency = randf_range(0.005, 0.01)
	Globals.world_data_dictionary.map_noise_lacunality = randf_range(1.5, 2.5)
	Globals.world_data_dictionary.map_noise_gain = randf_range(0.3, 0.7)
	Globals.world_data_dictionary.map_noise_strenght = randf_range(0.0, 0.4)
	DataManagement.world_save("user://saves/" + save_name_editor.text + ".txt")
	Globals.game_data_dictionary.saves.append(save_name_editor.text)
	save_name_editor.text = _randomize_save_name()
	save_seed_editor.text = str(_randomize_save_seed())
	save_creation_container.hide()
	create_save_button.disabled = false
	DataManagement.load_world_save(DataManagement.current_save)
	DataManagement.save_game_save()
	_update_saves_list()

func _on_randomize_button_up() -> void:
	save_name_editor.text = _randomize_save_name()
	save_seed_editor.text = str(_randomize_save_seed())

func _on_cancel_button_up() -> void:
	save_name_editor.text = _randomize_save_name()
	save_seed_editor.text = str(_randomize_save_seed())
	save_creation_container.hide()
	create_save_button.disabled = false

func _on_play_save_button_up() -> void:
	DataManagement.load_world_save("user://saves/" + saves_list.get_item_text(_selected_save_index) + ".txt")
	LoadingScreen.load_default_map()

func _on_delete_save_button_up() -> void:
	DirAccess.remove_absolute("user://saves/" + DataManagement.current_save + ".txt")
	Globals.game_data_dictionary.saves.erase(DataManagement.current_save)
	DataManagement.current_save = ""
	saves_list.deselect(_selected_save_index)
	_selected_save_index = -1
	_update_saves_list()
	DataManagement.save_game_save()
	delete_save_button.disabled = true
