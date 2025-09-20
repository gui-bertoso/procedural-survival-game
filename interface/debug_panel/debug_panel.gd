extends Control

func _process(_delta: float) -> void:
	$Panel/VBoxContainer/VBoxContainer/HBoxContainer/Label3.text = str(int(Engine.get_frames_per_second()))
	$Panel/VBoxContainer/VBoxContainer/HBoxContainer2/Label3.text = str("%.1f" % _delta) + "ms"
	
	$Panel/VBoxContainer/VBoxContainer/HBoxContainer3/Label3.text = str(Globals.player.can_rise).to_upper()
	
	$Panel/VBoxContainer/VBoxContainer/HBoxContainer4/Label3.text = str(Globals.player.climb_0).to_upper()
	$Panel/VBoxContainer/VBoxContainer/HBoxContainer5/Label3.text = str(Globals.player.climb_1).to_upper()
	$Panel/VBoxContainer/VBoxContainer/HBoxContainer6/Label3.text = str(Globals.player.climb_2).to_upper()
	$Panel/VBoxContainer/VBoxContainer/HBoxContainer7/Label3.text = str(Globals.player.climb_3).to_upper()


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
