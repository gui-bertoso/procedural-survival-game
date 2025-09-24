extends Control

@onready var fps_label: Label = $DataPanel/VContainer/VContainer/FPS/Value
@onready var frametime_label: Label = $DataPanel/VContainer/VContainer/Frametime/Value
@onready var can_rise_label: Label = $DataPanel/VContainer/VContainer/CanRise/Value
@onready var rise_v0_label: Label = $DataPanel/VContainer/VContainer/RiseV0/Value
@onready var rise_v1_label: Label = $DataPanel/VContainer/VContainer/RiseV1/Value
@onready var rise_v2_label: Label = $DataPanel/VContainer/VContainer/RiseV2/Value
@onready var rise_v3_label: Label = $DataPanel/VContainer/VContainer/RiseV3/Value

func _process(_delta: float) -> void:
	fps_label.text = str(int(Engine.get_frames_per_second()))
	frametime_label.text = str("%.1f" % _delta) + "ms"
	
	can_rise_label.text = str(Globals.player.can_rise).to_upper()
	
	rise_v0_label.text = str(Globals.player.rise_0).to_upper()
	rise_v1_label.text = str(Globals.player.rise_1).to_upper()
	rise_v2_label.text = str(Globals.player.rise_2).to_upper()
	rise_v3_label.text = str(Globals.player.rise_3).to_upper()


func _on_button_button_up() -> void:
	RenderingServer.set_debug_generate_wireframes(true)
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME

func _on_button_2_button_up() -> void:
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_OVERDRAW

func _on_button_3_button_up() -> void:
	RenderingServer.set_debug_generate_wireframes(false)
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_DISABLED


func _on_button_4_button_up() -> void:
	pass


func _on_button_5_button_up() -> void:
	pass # Replace with function body.


func _on_button_6_button_up() -> void:
	pass # Replace with function body.


func _on_button_7_button_up() -> void:
	pass # Replace with function body.


func _on_button_8_button_up() -> void:
	pass # Replace with function body.


func _on_button_9_button_up() -> void:
	pass # Replace with function body.


func _on_button_10_button_up() -> void:
	pass # Replace with function body.
