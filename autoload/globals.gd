extends Node

var stats_container: StatsContainer = null
var player_stats: CharacterStats = null
var player: Character = null
var hotbar: Hotbar = null
var inventory: Inventory = null
var hud: HUD = null

var on_menu: bool = false

var game_data_dictionary: Dictionary = {
	"window_mode": 0,
	"window_size": 0,
	"frame_rate": 0,
	"v_sync": 0,
	"fsr": 0,
	"preset": 0,
	"terrain_quality": 0,
	"textures_quality": 0,
	"effects_quality": 0,
	"particles_quality": 0,
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

var world_data_dictionary: Dictionary = {
	"first_read": true,
	
	"player_position": Vector3(0, 0, 0),
	"player_rotation": Vector3(0, 0, 0),
	
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
	
	"player_camera_rotation": Vector3(0, 0, 0),
	
	"inventory_data": [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	"inventory_data_amounts": [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0,0, 0, 0, 0, 0,0, 0, 0, 0, 0,0, 0, 0, 0, 0,0, 0, 0, 0, 0,0, 0, 0, 0, 0,0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0],
	
	"selected_hotbar_slot": 0,
}

func show_mouse() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		on_menu = true
func hide_mouse() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		on_menu = false

func apply_game_settings() -> void:
	match game_data_dictionary.language:
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("pt")
		2:
			TranslationServer.set_locale("pt_BR")
		3:
			TranslationServer.set_locale("fr")
		4:
			TranslationServer.set_locale("de")
		5:
			TranslationServer.set_locale("zh")
		6:
			TranslationServer.set_locale("ru")
