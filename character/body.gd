extends Node3D
class_name CharacterBody

@export var animation: AnimationPlayer = null
@export var character: Character = null

var animation_to_play: String = "idle"

func _process(_delta: float) -> void:
	animate()

func animate() -> void:
	if character.velocity.x or character.velocity.z:
		if character.is_spling:
			animation_to_play = "spring"
		else:
			animation_to_play = "walk"
	else:
		animation_to_play = "idle"
	
	if not animation.is_playing() or (animation.is_playing() and not animation.current_animation.begins_with(animation_to_play)):
		animation.play(animation_to_play)
