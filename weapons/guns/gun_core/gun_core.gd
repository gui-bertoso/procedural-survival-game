extends Node3D
class_name GunCore

@onready var pipe_snap = $ComponentsSnaps/PipeSnap
@onready var handle_snap = $ComponentsSnaps/HandleSnap
@onready var butt_snap = $ComponentsSnaps/ButtSnap

var pipe = null
var butt = null
var handle = null

var modifications = []

var in_bench = false

var debug_mods_dict = {
	"pipe": preload("res://weapons/guns/gun_pipe/gun_pipe_0.tscn"),
	"handle": preload("res://weapons/guns/gun_handle/gun_handle_0.tscn"),
	"butt": preload("res://weapons/guns/gun_butt/gun_butt_0.tscn"),
}

func _ready() -> void:
	if in_bench: return
	apply_modifications(debug_mods_dict)

func apply_modifications(modifications: Dictionary):
	for modification in modifications:
		var modificator_scene: Node3D = modifications[modification].instantiate()
		match modification:
			"pipe":
				pipe_snap.add_child(modificator_scene)
				pipe = modificator_scene
			"butt":
				butt_snap.add_child(modificator_scene)
				butt = modificator_scene
			"handle":
				handle_snap.add_child(modificator_scene)
				handle = modificator_scene
	print("Gun Mods Aplied")
