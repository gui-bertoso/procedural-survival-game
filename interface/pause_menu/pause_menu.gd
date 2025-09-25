extends Control
class_name PauseMenu

@onready var settings_screen: SettingsScreen = $SettingsScreen

func _on_resume_button_up() -> void:
	get_parent().hide_pause_menu()

func _on_save_button_up() -> void:
	DataManagement.save_game_save()
	DataManagement.world_save(DataManagement.current_save)

func _on_menu_button_up() -> void:
	settings_screen.show()

func _on_quit_button_up() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_settings_back_button_up() -> void:
	settings_screen.hide()
