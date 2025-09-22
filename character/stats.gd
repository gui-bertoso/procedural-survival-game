extends Node
class_name CharacterStats

var base_health = 100
var addicional_health = 0

var base_stamina = 100
var addicional_stamina = 0

var base_hunger = 100
var addicional_hunger = 0

var base_thirst = 100
var addicional_thirst = 0

var base_movement_speed = 3
var addicional_movement_speed = 0

var base_jump_force = 10
var addicional_jump_force = 0

var movement_speed = 0
var health = 0
var stamina = 0
var hunger = 0
var thirst = 0
var jump_force = 0

var max_movement_speed = 0
var max_health = 0
var max_stamina = 0
var max_hunger = 0
var max_thirst = 0
var max_jump_force = 0

func _enter_tree() -> void:
	Globals.player_stats = self

func _ready() -> void:
	if not Globals.world_data_dictionary.first_read:
		_load_stats()
	_set_max_stats()
	_set_stats()
	_update_hud()

func _load_stats() -> void:
	movement_speed = Globals.world_data_dictionary.player_movement_speed
	health = Globals.world_data_dictionary.player_health
	stamina = Globals.world_data_dictionary.player_stamina
	hunger = Globals.world_data_dictionary.player_hunger
	thirst = Globals.world_data_dictionary.player_thirst
	jump_force = Globals.world_data_dictionary.player_jump_force
	
	base_movement_speed = Globals.world_data_dictionary.player_base_movement_speed
	base_health = Globals.world_data_dictionary.player_base_health
	base_stamina = Globals.world_data_dictionary.player_base_stamina
	base_hunger = Globals.world_data_dictionary.player_base_hunger
	base_thirst = Globals.world_data_dictionary.player_base_thirst
	base_jump_force = Globals.world_data_dictionary.player_base_jump_force
	
	addicional_movement_speed = Globals.world_data_dictionary.player_addicional_movement_speed
	addicional_health = Globals.world_data_dictionary.player_addicional_health
	addicional_stamina = Globals.world_data_dictionary.player_addicional_stamina
	addicional_hunger = Globals.world_data_dictionary.player_addicional_hunger
	addicional_thirst = Globals.world_data_dictionary.player_addicional_thirst
	addicional_jump_force = Globals.world_data_dictionary.player_addicional_jump_force

func _save_stats() -> void:
	Globals.world_data_dictionary.player_movement_speed = movement_speed
	Globals.world_data_dictionary.player_health = health
	Globals.world_data_dictionary.player_stamina = stamina
	Globals.world_data_dictionary.player_hunger = hunger
	Globals.world_data_dictionary.player_thirst = thirst
	Globals.world_data_dictionary.player_jump_force = jump_force
	
	Globals.world_data_dictionary.player_base_movement_speed = base_movement_speed
	Globals.world_data_dictionary.player_base_health = base_health
	Globals.world_data_dictionary.player_base_stamina = base_stamina
	Globals.world_data_dictionary.player_base_hunger = base_hunger
	Globals.world_data_dictionary.player_base_thirst = base_thirst
	Globals.world_data_dictionary.player_base_jump_force = base_jump_force
	
	Globals.world_data_dictionary.player_addicional_movement_speed = addicional_movement_speed
	Globals.world_data_dictionary.player_addicional_health = addicional_health
	Globals.world_data_dictionary.player_addicional_stamina = addicional_stamina
	Globals.world_data_dictionary.player_addicional_hunger = addicional_hunger
	Globals.world_data_dictionary.player_addicional_thirst = addicional_thirst
	Globals.world_data_dictionary.player_addicional_jump_force = addicional_jump_force

func _set_stats() -> void:
	movement_speed = base_movement_speed + addicional_movement_speed
	health = base_health + addicional_health
	stamina = base_stamina + addicional_stamina
	hunger = base_hunger + addicional_hunger
	thirst = base_thirst + addicional_thirst
	jump_force = base_jump_force + addicional_jump_force

func _set_max_stats() -> void:
	max_movement_speed = base_movement_speed + addicional_movement_speed
	max_health = base_health + addicional_health
	max_stamina = base_stamina + addicional_stamina
	max_hunger = base_hunger + addicional_hunger
	max_thirst = base_thirst + addicional_thirst
	max_jump_force = base_jump_force + addicional_jump_force

func update_stat(_stat: String, _type: String, _value: float) -> void:
	match _type:
		"+":
			match _stat:
				"health":
					health += _value
					if health > max_health:
						health = max_health
				"stamina":
					stamina += _value
					if stamina > max_stamina:
						stamina = max_stamina
				"hunger":
					hunger += _value
					if hunger > max_hunger:
						hunger = max_hunger
				"thirst":
					thirst += _value
					if thirst > max_thirst:
						thirst = max_thirst
				"max_health":
					addicional_health += _value
					_set_max_stats()
				"max_stamina":
					addicional_stamina += _value
					_set_max_stats()
				"max_hunger":
					addicional_hunger += _value
					_set_max_stats()
				"max_thirst":
					addicional_thirst += _value
					_set_max_stats()
		"-":
			match _stat:
				"health":
					health -= _value
					if health < 0:
						health = 0
				"stamina":
					stamina -= _value
					if stamina < 0:
						stamina = 0
				"hunger":
					hunger -= _value
					if hunger < 0:
						hunger = 0
				"thirst":
					thirst -= _value
					if thirst < 0:
						thirst = 0
				"max_health":
					addicional_health -= _value
					_set_max_stats()
				"max_stamina":
					addicional_stamina -= _value
					_set_max_stats()
				"max_hunger":
					addicional_hunger -= _value
					_set_max_stats()
				"max_thirst":
					addicional_thirst -= _value
					_set_max_stats()
	_update_hud()

func _update_hud() -> void:
	Globals.stats_container.update_values()
	_save_stats()

func _exit_tree() -> void:
	_save_stats()
