extends Resource
class_name Item

@export var item_name: String = "ItemName"
@export var item_descryption: String = "A item"
@export_enum("resource", "weapon", "equipable") var item_type: String = ""
@export var item_image: Texture2D = preload("uid://ri6oq4y3srj1")

@export_category("Subtypes")
@export_enum("head_armor", "body_armor", "leg_armor", "foot_armor", "head_armor") var equipable_type: String = ""
@export_enum("gun", "sword", "knight", "axe", "pickaxe", "shovel", "hammer") var weapon_type: String = ""

@export_category("3D")
@export var item_mesh: PackedScene = preload("uid://d4dd4jvhoe24o")
@export var item_scene: PackedScene = null

@export_category("Others")
@export var item_durability: int = 100
@export var item_current_durability: int = 100
@export var item_stack: int = 16
@export var item_effects = []

@export_category("Craft")
@export var item_craft_recipe: Dictionary[Item, int] = {}
@export var item_craft_quantity: int = 1

@export_category("Modifications")
@export var modifications: Dictionary = {}

var item_amount: int = 1
