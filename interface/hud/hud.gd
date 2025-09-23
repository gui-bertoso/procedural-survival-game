extends CanvasLayer
class_name HUD

var on_pause_menu = false
var on_inventory = false

func _enter_tree() -> void:
	Globals.hud = self

func _process(_delta: float) -> void:
	pause_menu()
	inventory()

func pause_menu() -> void:
	if Input.is_action_just_pressed("ui_pause"):
		if on_pause_menu:
			hide_pause_menu()
		else:
			show_pause_menu()

func inventory() -> void:
	if on_pause_menu: return
	if Input.is_action_just_pressed("ui_inventory"):
		if on_inventory:
			hide_inventory()
		else:
			show_inventory()

func show_pause_menu() -> void:
	on_pause_menu = true
	on_inventory = false
	$PauseMenu.visible = true
	$Inventory.visible = false
	$DebugPanel.visible = false
	$Hotbar.visible = false
	Globals.show_mouse()
	get_tree().paused = true

func hide_pause_menu() -> void:
	on_pause_menu = false
	on_inventory = false
	$PauseMenu.visible = false
	$Inventory.visible = false
	$DebugPanel.visible = true
	$Hotbar.visible = true
	Globals.hide_mouse()
	get_tree().paused = false

func show_inventory() -> void:
	on_inventory = true
	$Inventory.visible = true
	$DebugPanel.visible = false
	$Hotbar.visible = false
	Globals.show_mouse()

func hide_inventory() -> void:
	on_inventory = false
	$Inventory.visible = false
	$DebugPanel.visible = true
	$Hotbar.visible = true
	Globals.hide_mouse()

func show_craft_interface(craft_recipes:Array) -> void:
	on_inventory = false
	$Inventory.visible = false
	$DebugPanel.visible = false
	$Target.visible = false
	$Hotbar.visible = false
	$CraftInterface.crafts = craft_recipes
	$CraftInterface.load_recipes()
	$CraftInterface.visible = true
	Globals.show_mouse()
	
func show_gun_bench_interface() -> void:
	on_inventory = false
	$Inventory.visible = false
	$DebugPanel.visible = false
	$Target.visible = false
	$GunBench.visible = true
	$GunBench.init_camera_atributes()
	Globals.show_mouse()
func hide_gun_bench_interface() -> void:
	on_inventory = false
	$Inventory.visible = false
	$DebugPanel.visible = true
	$Target.visible = true
	$GunBench.visible = false
	Globals.hide_mouse()

func hide_craft_interface() -> void:
	on_inventory = false
	$Inventory.visible = false
	$DebugPanel.visible = true
	$Target.visible = true
	$Hotbar.visible = true
	$CraftInterface.visible = false
	Globals.hide_mouse()
