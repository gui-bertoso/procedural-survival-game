extends Node
class_name GunModification

@export var modification_name = "Modification"
@export var modification_image = preload("res://assets/Sprite-0006.png")
@export var modification_ingredients: Dictionary[Item, int] = {}
@export var modification_scene: PackedScene = null
