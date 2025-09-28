extends Node

var _game_save_path: String = "user://saves/game_save.txt"

var current_save: String = ""

func _ready() -> void:
	load_game_save()
	Globals.apply_game_settings()

func save_game_save() -> void:
	if not FileAccess.file_exists("user://saves"):
		DirAccess.make_dir_absolute("user://saves")
	var _file := FileAccess.open(_game_save_path, FileAccess.WRITE)
	_file.store_var(Globals.game_data_dictionary.duplicate(true), true)
	_file.close()
func load_game_save() -> void:
	if FileAccess.file_exists(_game_save_path):
		var _file := FileAccess.open(_game_save_path, FileAccess.READ)
		Globals.game_data_dictionary = _file.get_var(true)
		_file.close()

func world_save(save_path: String) -> void:
	if current_save == "": return
	var _file := FileAccess.open(save_path, FileAccess.WRITE)
	_file.store_var(Globals.world_data_dictionary, true)
	_file.close()
	current_save = save_path
	load_world_save(save_path)
func load_world_save(save_path: String) -> void:
	if FileAccess.file_exists(save_path):
		var _file := FileAccess.open(save_path, FileAccess.READ)
		Globals.world_data_dictionary = _file.get_var(true)
		current_save = save_path
		_file.close()

func resave_world() -> void:
	if current_save:
		var _file := FileAccess.open(current_save, FileAccess.WRITE)
		_file.store_var(Globals.world_data_dictionary.duplicate(true), true)
		current_save = current_save
		_file.close()
func reload_world() -> void:
	var _file := FileAccess.open(current_save, FileAccess.READ)
	Globals.world_data_dictionary = _file.get_var(true)
	current_save = current_save
	_file.close()

func _exit_tree() -> void:
	save_game_save()
