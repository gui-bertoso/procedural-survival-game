extends CanvasLayer

@export var animation: AnimationPlayer = null
@export var tip_label: Label = null

@onready var tips_list: Array[String] = [
	"This game is not a copy of minecraft, terraria is not a copy of minecraft.",
	"Progress is the friends we make along the way.",
	"Don't put off until today what you can do tomorrow.",
	"You probably haven't discovered all the secrets of this game yet.",
	"Reading is important...books are for reading...someone may have written useful things out there, right?",
	"Sleep, eat and hydrate so you don't get sick on your adventures.",
	"This game was made by a random guy looking for a game that gives freedom to the player."
]

var loading: bool = false

func _process(_delta: float) -> void:
	if loading:
		var progress: Array = []
		ResourceLoader.load_threaded_get_status("res://map/default_map/default_map.tscn", progress)
		if progress[0] == 1:
			var packed_scene: PackedScene = ResourceLoader.load_threaded_get("res://map/default_map/default_map.tscn")
			get_tree().change_scene_to_packed(packed_scene)
			await get_tree().create_timer(7.0).timeout
			animation.play("fade_out")
			loading = false

func randomize_tip() -> void:
	if tip_label == null:
		tip_label = $Background/Tip
	tip_label.text = tips_list[randi_range(0, tips_list.size()-1)]

func load_default_map() -> void:
	randomize_tip()
	animation.play("fade_in")

func load_scene() -> void:
	ResourceLoader.load_threaded_request("res://map/default_map/default_map.tscn")
	loading = true
