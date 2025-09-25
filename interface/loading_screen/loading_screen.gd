extends Control
class_name LoadingScreen

@onready var tip_label: Label = $Background/Tip

@onready var tips_list: Array[String] = [
	"This game is not a copy of minecraft, terraria is not a copy of minecraft.",
	"Progress is the friends we make along the way.",
	"Don't put off until today what you can do tomorrow.",
	"You probably haven't discovered all the secrets of this game yet.",
	"Reading is important...books are for reading...someone may have written useful things out there, right?",
	"Sleep, eat and hydrate so you don't get sick on your adventures.",
	"This game was made by a random guy looking for a game that gives freedom to the player."
]

func _ready() -> void:
	tip_label.text = tips_list[randi_range(0, tips_list.size()-1)]
