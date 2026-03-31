extends CanvasLayer

@export var animation: AnimationPlayer
@export var tip_label: Label

const MAP_PATH := "res://map/default_map/default_map.tscn"

var loading := false
var progress := [0.0]

@onready var tips_list := [
	"This game is not a copy of minecraft.",
	"Progress is the friends we make along the way.",
	"Stay hydrated, dev.",
	"Procedural chaos is still chaos.",
	"Optimize or cry later."
]

func _process(_delta: float) -> void:
	if not loading:
		return

	var status = ResourceLoader.load_threaded_get_status(MAP_PATH, progress)

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		_finish_loading()

func _finish_loading() -> void:
	var packed_scene: PackedScene = ResourceLoader.load_threaded_get(MAP_PATH)
	get_tree().change_scene_to_packed(packed_scene)
	await get_tree().create_timer(0.5).timeout
	animation.play("fade_out")
	loading = false

func randomize_tip() -> void:
	if tip_label == null:
		tip_label = $Background/Tip
	tip_label.text = tips_list[randi_range(0, tips_list.size() - 1)]

func load_default_map() -> void:
	randomize_tip()
	animation.play("fade_in")
	ResourceLoader.load_threaded_request(MAP_PATH)
	loading = true
