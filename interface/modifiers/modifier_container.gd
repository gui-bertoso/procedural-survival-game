extends ColorRect

func set_mod(modification: GunModification):
	$TextureRect.texture = modification.modification_image
	$Label.text = modification.modification_name
