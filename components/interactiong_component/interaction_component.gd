extends Node

@export var _a: Control

func _process(_delta: float) -> void:
	if get_parent().interacting:
		if Input.is_action_just_pressed("ui_interact"):
			_a.visible = !_a.visible
			if _a.visible:
				Globals.hud.in_interactive_interface()
			else:
				Globals.hud.out_interactive_interface()
	
