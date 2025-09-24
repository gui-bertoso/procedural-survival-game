extends Control
class_name StatsContainer

@onready var health_bar: ProgressBar = $BigBar/HealthBar
@onready var stamina_bar: ProgressBar = $BigBar/StaminaBar
@onready var hunger_bar: ProgressBar = $LittleBars/HungerBar
@onready var thirst_bar: ProgressBar = $LittleBars/ThirstBar

func _enter_tree() -> void:
	Globals.stats_container = self

func update_values() -> void:
	health_bar.max_value = Globals.player_stats.max_health
	stamina_bar.max_value = Globals.player_stats.max_stamina
	hunger_bar.max_value = Globals.player_stats.max_hunger
	thirst_bar.max_value = Globals.player_stats.max_thirst
	
	health_bar.value = Globals.player_stats.health
	stamina_bar.value = Globals.player_stats.stamina
	hunger_bar.value = Globals.player_stats.hunger
	thirst_bar.value = Globals.player_stats.thirst
