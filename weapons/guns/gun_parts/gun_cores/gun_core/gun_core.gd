extends Node3D
class_name GunCore

@onready var pipe_snap = $ComponentsSnaps/PipeSnap
@onready var handle_snap = $ComponentsSnaps/HandleSnap
@onready var butt_snap = $ComponentsSnaps/ButtSnap
@onready var scope_snap = $ComponentsSnaps/ScopeSnap

var pipe: GunPipe = null
var butt: GunButt = null
var handle: GunHandle = null
var scope: GunScope = null

var modifications = []

var in_bench = false

@export var precision = 70.0
@export var damage = 7.0
@export var fire_cadense = 5
@export var recoil = 2.5
@export var max_ammo = 31
@export var fire_range = 100.0
@export var reload_time = 12.5
@export var ammo = 0

func _ready() -> void:
	apply_modifications(modifications)

func apply_modifications(modifications: Dictionary):
	for modification in modifications:
		var modificator_scene: GunModification = modifications[modification]
		match modification:
			"pipe":
				var a = modificator_scene.modification_scene.instantiate()
				pipe_snap.add_child(a)
				pipe = a
				precision += pipe.precision
				fire_range += pipe.fire_range
			"butt":
				var a = modificator_scene.modification_scene.instantiate()
				butt_snap.add_child(a)
				butt = a
				precision += butt.precision
				recoil += butt.precision
			"handle":
				var a = modificator_scene.modification_scene.instantiate()
				handle_snap.add_child(a)
				handle = a
				precision += handle.precision
				recoil += butt.precision
			"scope":
				var a = modificator_scene.modification_scene.instantiate()
				scope_snap.add_child(a)
				scope = a
				precision += scope.precision
	
	if precision <= 0:
		precision = 0
	if recoil <= 0:
		recoil = 0
	if reload_time <= 0:
		reload_time = 0
	if fire_cadense <= 0:
		fire_cadense = 0
	if fire_range <= 0:
		fire_range = 0
	if max_ammo <= 0:
		max_ammo = 0
	if damage <= 0:
		damage = 0
	print("Gun Mods Aplied")
