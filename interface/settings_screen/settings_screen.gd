extends Control
class_name SettingsScreen

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://interface/main_menu/main_menu.tscn")

func _on_apply_button_up() -> void:
	Globals.apply_game_settings()

func _ready() -> void:
	DataManagement.load_game_save()
	load_options()
	connect_controls_remap()
	connect_video_options()
	connect_audio_options()

func connect_audio_options() -> void:
	for i in $TabContainer/Audio/ScrollContainer/VBoxContainer3/VBoxContainer.get_children():
		if i is HBoxContainer:
			i.get_node("HScrollBar").value_changed.connect(volume_changed.bind(i.get_node("Label").text.to_snake_case(), i.get_node("Label2")))

func connect_video_options() -> void:
	for i in $TabContainer/Video/ScrollContainer/VBoxContainer3/VBoxContainer/VBoxContainer.get_children():
		i.get_node("OptionButton").item_selected.connect(option_selected.bind(i.get_node("Label").text.to_snake_case()))
	for i in $TabContainer/Video/ScrollContainer/VBoxContainer3/VBoxContainer2/VBoxContainer.get_children():
		i.get_node("OptionButton").item_selected.connect(option_selected.bind(i.get_node("Label").text.to_snake_case()))
	for i in $TabContainer/Gameplay/ScrollContainer/VBoxContainer3/VBoxContainer/VBoxContainer.get_children():
		i.get_node("OptionButton").item_selected.connect(option_selected.bind(i.get_node("Label").text.to_snake_case()))

func connect_controls_remap() -> void:
	for i in $TabContainer/Controls/ScrollContainer/VBoxContainer3/VBoxContainer3.get_children():
		i.mouse_entered.connect(control_key_interact.bind("entered", i))
		i.mouse_exited.connect(control_key_interact.bind("exited", i))

func volume_changed(value: int, option_name: String, option_percentage_label: Label):
	match option_name:
		"general_volume":
			Globals.game_data_dictionary.general_volume = value
			option_percentage_label.text = str(value)
		"vehicles_volume":
			Globals.game_data_dictionary.vehicles_volume = value
			option_percentage_label.text = str(value)
		"enemys_volume":
			Globals.game_data_dictionary.enemys_volume = value
			option_percentage_label.text = str(value)
		"musics_volume":
			Globals.game_data_dictionary.musics_volume = value
			option_percentage_label.text = str(value)
		"effects_volume":
			Globals.game_data_dictionary.effects_volume = value
			option_percentage_label.text = str(value)

func load_options():
	for i in $TabContainer/Audio/ScrollContainer/VBoxContainer3/VBoxContainer.get_children():
		if i is HBoxContainer:
			match i.get_node("Label").text.to_snake_case():
				"general_volume":
					i.get_node("HScrollBar").value = Globals.game_data_dictionary.general_volume
					i.get_node("Label2").text = str(Globals.game_data_dictionary.general_volume)
				"musics_volume":
					i.get_node("HScrollBar").value = Globals.game_data_dictionary.musics_volume
					i.get_node("Label2").text = str(Globals.game_data_dictionary.musics_volume)
				"vehicles_volume":
					i.get_node("HScrollBar").value = Globals.game_data_dictionary.vehicles_volume
					i.get_node("Label2").text = str(Globals.game_data_dictionary.vehicles_volume)
				"enemys_volume":
					i.get_node("HScrollBar").value = Globals.game_data_dictionary.enemys_volume
					i.get_node("Label2").text = str(Globals.game_data_dictionary.enemys_volume)
				"effects_volume":
					i.get_node("HScrollBar").value = Globals.game_data_dictionary.effects_volume
					i.get_node("Label2").text = str(Globals.game_data_dictionary.effects_volume)
	var t_objs = []
	for i in $TabContainer/Video/ScrollContainer/VBoxContainer3/VBoxContainer/VBoxContainer.get_children():
		t_objs.append(i)
	for i in $TabContainer/Video/ScrollContainer/VBoxContainer3/VBoxContainer2/VBoxContainer.get_children():
		t_objs.append(i)
	for i in $TabContainer/Gameplay/ScrollContainer/VBoxContainer3/VBoxContainer/VBoxContainer.get_children():
		t_objs.append(i)
	
	for i in t_objs:
		match i.get_node("Label").text.to_snake_case():
			"window_mode":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.window_mode)
			"window_size":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.window_size)
			"frame_rate":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.frame_rate)
			"v_sync":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.v_sync)
			"fsr":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.fsr)
			"preset":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.preset)
			"render_distance":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.render_distance)
			"terrain_quality":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.terrain_quality)
			"envinroment_quality":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.envinroment_quality)
			"textures_quality":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.textures_quality)
			"effects_quality":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.effects_quality)
			"particles_quality":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.particles_quality)
			"vegetation_quality":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.vegetation_quality)
			"autojump":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.autojump)
			"dynamic_fov":
				i.get_node("OptionButton").select(Globals.game_data_dictionary.dynamic_fov)

func option_selected(option_index: int, option_name: String) -> void:
	match option_name:
		"window_mode":
			Globals.game_data_dictionary.window_mode = option_index
		"window_size":
			Globals.game_data_dictionary.window_size = option_index
		"framerate":
			Globals.game_data_dictionary.framerate = option_index
		"v_sync":
			Globals.game_data_dictionary.v_sync = option_index
		"fsr":
			Globals.game_data_dictionary.fsr = option_index
		"preset":
			Globals.game_data_dictionary.preset = option_index
		"render_distance":
			Globals.game_data_dictionary.render_distance = option_index
		"terrain_quality":
			Globals.game_data_dictionary.terrain_quality = option_index
		"envinroment_quality":
			Globals.game_data_dictionary.envinroment_quality = option_index
		"textures_quality":
			Globals.game_data_dictionary.textures_quality = option_index
		"effects_quality":
			Globals.game_data_dictionary.effects_quality = option_index
		"particles_quality":
			Globals.game_data_dictionary.particles_quality = option_index
		"vegetation_quality":
			Globals.game_data_dictionary.vegetation_quality = option_index
		"autojump":
			Globals.game_data_dictionary.autojump = option_index
		"dynamic_fov":
			Globals.game_data_dictionary.dynamic_fov = option_index
	DataManagement.save_game_save()

func control_key_interact(type: String, key: HBoxContainer) -> void:
	if type == "entered":
		key.get_node("LabelKey").modulate = Color(1.0, 1.0, 0.0, 1.0)
		key.get_node("LabelKey2").modulate = Color(1.0, 1.0, 0.0, 1.0)
		key.get_node("LabelKey3").modulate = Color(1.0, 1.0, 0.0, 1.0)
	else:
		key.get_node("LabelKey").modulate = Color(1.0, 1.0, 1.0, 1.0)
		key.get_node("LabelKey2").modulate = Color(1.0, 1.0, 1.0, 1.0)
		key.get_node("LabelKey3").modulate = Color(1.0, 1.0, 1.0, 1.0)
