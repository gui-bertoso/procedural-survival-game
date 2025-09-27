extends Control
class_name DebugPanel

@onready var fps_label: Label = $DataPanel/VContainer/VContainer/FPS/Value
@onready var frametime_label: Label = $DataPanel/VContainer/VContainer/Frametime/Value
@onready var can_rise_label: Label = $DataPanel/VContainer/VContainer/CanRise/Value
@onready var rise_v0_label: Label = $DataPanel/VContainer/VContainer/RiseV0/Value
@onready var rise_v1_label: Label = $DataPanel/VContainer/VContainer/RiseV1/Value
@onready var rise_v2_label: Label = $DataPanel/VContainer/VContainer/RiseV2/Value
@onready var rise_v3_label: Label = $DataPanel/VContainer/VContainer/RiseV3/Value
@onready var current_item_class_label: Label = $DataPanel/VContainer/VContainer/CurrentItemClass/Value

func _process(_delta: float) -> void:
	fps_label.text = str(int(Engine.get_frames_per_second()))
	frametime_label.text = str("%.4f" % _delta) + "ms"
	if Globals.player == null: return
	can_rise_label.text = str(Globals.player.can_rise).to_upper()
	
	rise_v0_label.text = str(Globals.player.rise_0).to_upper()
	rise_v1_label.text = str(Globals.player.rise_1).to_upper()
	rise_v2_label.text = str(Globals.player.rise_2).to_upper()
	rise_v3_label.text = str(Globals.player.rise_3).to_upper()
	
	current_item_class_label.text = Globals.player_hand.current_item_class

func _on_button_button_up() -> void:
	RenderingServer.set_debug_generate_wireframes(true)
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME

func _on_button_2_button_up() -> void:
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_OVERDRAW

func _on_button_3_button_up() -> void:
	RenderingServer.set_debug_generate_wireframes(false)
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_DISABLED
