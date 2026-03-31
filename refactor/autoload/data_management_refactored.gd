extends Node

const SAVE_DIR := "user://saves"
const GAME_SAVE_PATH := SAVE_DIR + "/game_save.dat"

var current_save: String = ""

func _ready() -> void:
	_ensure_save_dir()
	load_game_save()
	Globals.normalize_game_data()
	Globals.apply_game_settings()

func _ensure_save_dir() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)

func save_game_save() -> void:
	_ensure_save_dir()
	var file := FileAccess.open(GAME_SAVE_PATH, FileAccess.WRITE)
	file.store_var(Globals.game_data_dictionary.duplicate(true), true)
	file.close()

func load_game_save() -> void:
	if FileAccess.file_exists(GAME_SAVE_PATH):
		var file := FileAccess.open(GAME_SAVE_PATH, FileAccess.READ)
		Globals.game_data_dictionary = file.get_var(true)
		file.close()
	Globals.normalize_game_data()

func world_save(save_path: String) -> void:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Globals.world_data_dictionary.duplicate(true), true)
	file.close()
	current_save = save_path

func load_world_save(save_path: String) -> void:
	if FileAccess.file_exists(save_path):
		var file := FileAccess.open(save_path, FileAccess.READ)
		Globals.world_data_dictionary = file.get_var(true)
		current_save = save_path
		file.close()
	Globals.normalize_world_data()

func resave_world() -> void:
	if current_save == "":
		return
	var file := FileAccess.open(current_save, FileAccess.WRITE)
	file.store_var(Globals.world_data_dictionary.duplicate(true), true)
	file.close()

func reload_world() -> void:
	if current_save == "":
		return
	var file := FileAccess.open(current_save, FileAccess.READ)
	Globals.world_data_dictionary = file.get_var(true)
	file.close()
	Globals.normalize_world_data()

func _exit_tree() -> void:
	save_game_save()
