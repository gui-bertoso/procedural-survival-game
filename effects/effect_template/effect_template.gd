extends Node
class_name Effect

@export var effect_name = "Effect"
@export var effect_descryption = "A Effect"
@export var effect_duration = 1.0

func apply() -> void:
	pass

func update_duration(_type: String, _value: float) -> bool:
	match _type:
		"+":
			effect_duration += _value
			return false
		"-":
			effect_duration -= _value
			if effect_duration <= 0:
				return true
	return false
