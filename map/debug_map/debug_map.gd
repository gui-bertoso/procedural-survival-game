extends Node3D
class_name DebugMap

func _enter_tree() -> void:
	DataManagement.load_world_save(DataManagement.current_save)

func _exit_tree() -> void:
	Globals.world_data_dictionary.first_read = false
	DataManagement.world_save(DataManagement.current_save)
