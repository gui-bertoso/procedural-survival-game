extends Resource
class_name Item

@export var id: String = "item_id"
@export var name: String = "Item"
@export var description: String = "A simple item"

@export_enum("resource", "weapon", "equipable") var type: String

@export var stack_size: int = 16
@export var durability: int = 100

@export var mesh: PackedScene

@export var craft_recipe: Dictionary[String, int] = {}

var amount: int = 1
