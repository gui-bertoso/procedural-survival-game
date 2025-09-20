extends Control

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://interface/save_selection_screen/save_selection_screen.tscn")
func _on_settings_button_up() -> void:
	get_tree().change_scene_to_file("res://interface/settings_screen/settings_screen.tscn")
func _on_quit_button_up() -> void:
	get_tree().quit()
