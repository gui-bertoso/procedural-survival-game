extends Control
class_name StatsContainer

func _enter_tree() -> void:
	Globals.stats_container = self

func update_values() -> void:
	$Panel2/HealthBar.max_value = Globals.player_stats.max_health
	$Panel2/StaminaBar.max_value = Globals.player_stats.max_stamina
	$Panel/HungerBar.max_value = Globals.player_stats.max_hunger
	$Panel/ThirstBar.max_value = Globals.player_stats.max_thirst
	
	$Panel2/HealthBar.value = Globals.player_stats.health
	$Panel2/StaminaBar.value = Globals.player_stats.stamina
	$Panel/HungerBar.value = Globals.player_stats.hunger
	$Panel/ThirstBar.value = Globals.player_stats.thirst
