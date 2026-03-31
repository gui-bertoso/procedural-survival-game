extends Node

var stats_container: StatsContainer = null
var player_stats: CharacterStats = null
var player: Character = null
var hotbar: Hotbar = null
var inventory: Inventory = null
var hud: HUD = null
var player_hand: PlayerHand = null

var on_menu: bool = false

const DEFAULT_GAME_DATA := {
	"window_mode": 0,
	"window_size": 0,
	"frame_rate": 0,
	"v_sync": 0,
	"fsr_enabled": 0,
	"fsr_quality": 0,
	"preset": 0,
	"terrain_quality": 0,
	"textures_quality": 0,
	"effects_quality": 0,
	"particles_quality": 0,
	"environment_quality": 0,
	"envinroment_quality": 0,
	"render_distance": 0,
	"vegetation_quality": 0,
	"mouse_sensibility": 0.003,
	"dynamic_fov": 0,
	"autojump": 1,
	"general_volume": 50.0,
	"enemys_volume": 100.0,
	"vehicles_volume": 100.0,
	"musics_volume": 100.0,
	"effects_volume": 100.0,
	"language": 0,
	"saves": []
}

const DEFAULT_WORLD_DATA := {
	"first_read": true,
	"map_noise_seed": 0,
	"map_noise_strenght": 0,
	"map_noise_frequency": 0.01,
	"map_noise_gain": 0.5,
	"map_noise_lacunality": 2.0,
	"player_position": Vector3.ZERO,
	"player_rotation": Vector3.ZERO,
	"player_health": 100,
	"player_base_health": 100,
	"player_addicional_health": 0,
	"player_hunger": 100,
	"player_base_hunger": 100,
	"player_addicional_hunger": 0,
	"player_thirst": 100,
	"player_base_thirst": 100,
	"player_addicional_thirst": 0,
	"player_stamina": 100,
	"player_base_stamina": 100,
	"player_addicional_stamina": 0,
	"player_movement_speed": 3,
	"player_base_movement_speed": 3,
	"player_addicional_movement_speed": 0,
	"player_jump_force": 10,
	"player_base_jump_force": 10,
	"player_addicional_jump_force": 0,
	"player_camera_rotation": Vector3.ZERO,
	"inventory_data": [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
	"inventory_data_amounts": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	"current_hotbar_slot": 0
}

var game_data_dictionary: Dictionary = DEFAULT_GAME_DATA.duplicate(true)
var world_data_dictionary: Dictionary = DEFAULT_WORLD_DATA.duplicate(true)

func show_mouse() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		on_menu = true

func hide_mouse() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		on_menu = false

func get_environment_quality() -> int:
	if game_data_dictionary.has("environment_quality"):
		return int(game_data_dictionary.environment_quality)
	return int(game_data_dictionary.get("envinroment_quality", 0))

func normalize_game_data() -> void:
	var merged := DEFAULT_GAME_DATA.duplicate(true)
	for key in game_data_dictionary.keys():
		merged[key] = game_data_dictionary[key]
	merged.environment_quality = get_environment_quality()
	merged.envinroment_quality = merged.environment_quality
	game_data_dictionary = merged

func normalize_world_data() -> void:
	var merged := DEFAULT_WORLD_DATA.duplicate(true)
	for key in world_data_dictionary.keys():
		merged[key] = world_data_dictionary[key]
	world_data_dictionary = merged

func apply_game_settings() -> void:
	normalize_game_data()
	
	match int(game_data_dictionary.window_mode):
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	match int(game_data_dictionary.window_size):
		0:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		1:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		2:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
		3:
			DisplayServer.window_set_size(Vector2i(3840, 2160))
	
	match int(game_data_dictionary.frame_rate):
		0: Engine.max_fps = 30
		1: Engine.max_fps = 45
		2: Engine.max_fps = 60
		3: Engine.max_fps = 75
		4: Engine.max_fps = 90
		5: Engine.max_fps = 120
		6: Engine.max_fps = 144
		7: Engine.max_fps = 0
		_: Engine.max_fps = 60
	
	match int(game_data_dictionary.v_sync):
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		_:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	
	match int(game_data_dictionary.fsr_enabled):
		0:
			ProjectSettings.set_setting("rendering/scaling_3d/mode", "bilinear")
		1:
			ProjectSettings.set_setting("rendering/scaling_3d/mode", "fsr")
		2:
			ProjectSettings.set_setting("rendering/scaling_3d/mode", "fsr2")
		_:
			ProjectSettings.set_setting("rendering/scaling_3d/mode", "bilinear")
	
	if int(game_data_dictionary.fsr_enabled) > 0:
		match int(game_data_dictionary.fsr_quality):
			0:
				ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.5)
			1:
				ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.75)
			2:
				ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.9)
			_:
				ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.75)
	else:
		ProjectSettings.set_setting("rendering/scaling_3d/scale", 1.0)
	
	match int(game_data_dictionary.language):
		0: TranslationServer.set_locale("en")
		1: TranslationServer.set_locale("pt")
		2: TranslationServer.set_locale("pt_BR")
		3: TranslationServer.set_locale("es")
		4: TranslationServer.set_locale("fr")
		5: TranslationServer.set_locale("de")
		6: TranslationServer.set_locale("zh")
		7: TranslationServer.set_locale("ru")
		_: TranslationServer.set_locale("en")
