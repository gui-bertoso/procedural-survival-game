extends Resource
class_name Item

@export var item_name = "ItemName"
@export var item_descryption = "A item"
@export_enum("resource", "weapon", "equipable") var item_type = ""
@export var item_image: Texture2D = preload("res://assets/Sprite-0006.png")

@export_category("Subtypes")
@export_enum("head_armor", "body_armor", "leg_armor", "foot_armor", "head_armor") var equipable_type = ""
@export_enum("gun", "sword", "knight", "axe", "pickaxe", "shovel", "hammer") var weapon_type = ""

@export_category("3D")
@export var item_mesh: PackedScene = preload("res://assets/template_item_mesh/template_item_mesh.tscn")
@export var item_scene: PackedScene = null

@export_category("Others")
@export var item_durability = 100
@export var item_current_durability = 100
@export var item_stack = 16
@export var item_effects = []

@export_category("Craft")
@export var item_craft_recipe: Dictionary[Item, int] = {}
@export var item_craft_quantity: int = 1

var item_amount = 1
