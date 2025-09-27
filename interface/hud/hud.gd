extends CanvasLayer
class_name HUD

@onready var target: Target = $Target
@onready var stats_container: StatsContainer = $StatsContainer
@onready var inventory: Inventory = $Inventory
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var debug_panel: DebugPanel = $DebugPanel
@onready var craft_interface: CraftInterfaceComponent = $CraftInterface
@onready var gun_bench_interface: GunsBenchInterfaceComponent = $GunBench
@onready var hotbar: Hotbar = $Hotbar

var on_pause_menu: bool = false
var on_inventory: bool = false
var on_gun_bench: bool = false
var on_craft_interface: bool = false


func _enter_tree() -> void:
	Globals.hud = self

func _process(_delta: float) -> void:
	pause_menu_behavior()
	inventory_behavior()

func pause_menu_behavior() -> void:
	if Input.is_action_just_pressed("ui_pause"):
		if on_pause_menu:
			hide_pause_menu()
		else:
			show_pause_menu()

func inventory_behavior() -> void:
	if on_pause_menu or on_craft_interface or on_gun_bench: return
	if Input.is_action_just_pressed("ui_inventory"):
		if on_inventory:
			hide_inventory()
		else:
			show_inventory()

func show_pause_menu() -> void:
	on_pause_menu = true
	on_inventory = false
	pause_menu.visible = true
	inventory.visible = false
	debug_panel.visible = false
	hotbar.visible = false
	Globals.show_mouse()
	get_tree().paused = true

func hide_pause_menu() -> void:
	on_pause_menu = false
	on_inventory = false
	pause_menu.visible = false
	inventory.visible = false
	debug_panel.visible = true
	hotbar.visible = true
	Globals.hide_mouse()
	get_tree().paused = false

func show_inventory() -> void:
	on_inventory = true
	inventory.visible = true
	debug_panel.visible = false
	hotbar.visible = false
	Globals.show_mouse()

func hide_inventory() -> void:
	on_inventory = false
	inventory.visible = false
	debug_panel.visible = true
	hotbar.visible = true
	Globals.hide_mouse()
	
func show_gun_bench_interface() -> void:
	on_inventory = false
	inventory.visible = false
	debug_panel.visible = false
	target.visible = false
	gun_bench_interface.visible = true
	gun_bench_interface.init_camera_atributes()
	Globals.show_mouse()
	on_gun_bench = true
func hide_gun_bench_interface() -> void:
	on_inventory = false
	inventory.visible = false
	debug_panel.visible = true
	target.visible = true
	gun_bench_interface.visible = false
	Globals.hide_mouse()
	on_gun_bench = false

func show_craft_interface(craft_recipes:Array) -> void:
	on_inventory = false
	inventory.visible = false
	debug_panel.visible = false
	target.visible = false
	hotbar.visible = false
	craft_interface.crafts = craft_recipes
	craft_interface.load_recipes()
	craft_interface.visible = true
	Globals.show_mouse()
	on_craft_interface = true
func hide_craft_interface() -> void:
	on_inventory = false
	inventory.visible = false
	debug_panel.visible = true
	target.visible = true
	hotbar.visible = true
	craft_interface.visible = false
	Globals.hide_mouse()
	on_craft_interface = false
