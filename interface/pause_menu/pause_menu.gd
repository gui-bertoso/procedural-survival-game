extends Control

func _on_button_button_up() -> void:
	get_parent().hide_pause_menu()

func _on_button_2_button_up() -> void:
	DataManagement.save_game_save()
	DataManagement.world_save(DataManagement.current_save)

func _on_button_4_button_up() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_back_2_button_up() -> void:
	$SettingsScreen.hide()


func _on_button_3_button_up() -> void:
	$SettingsScreen.show()
