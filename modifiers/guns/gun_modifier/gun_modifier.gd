extends Resource
class_name GunModification

@export var modification_name: String = "Modification"
@export_enum("pipe", "butt", "scope", "handle") var modification_type: String = ""
@export var modification_image: CompressedTexture2D = preload("uid://ri6oq4y3srj1")
@export var modification_ingredients: Dictionary[Item, int] = {}
@export var modification_scene: PackedScene = null
