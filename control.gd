extends Control

@onready var core_snap = $SubViewportContainer/SubViewport/Node3D/Node3D/CoreSnap
var gun_core = null

var butts_list = [
	"",
	preload("res://weapons/guns/gun_butt/gun_butt_0.tscn"),
	preload("res://weapons/guns/gun_butt/gun_butt_1.tscn"),
	preload("res://weapons/guns/gun_butt/gun_butt_2.tscn"),
	preload("res://weapons/guns/gun_butt/gun_butt_3.tscn"),
	preload("res://weapons/guns/gun_butt/gun_butt_4.tscn"),
	preload("res://weapons/guns/gun_butt/gun_butt_5.tscn"),
	preload("res://weapons/guns/gun_butt/gun_butt_6.tscn")
]
var pipes_list = [
	"",
	preload("res://weapons/guns/gun_pipe/gun_pipe_0.tscn"),
	preload("res://weapons/guns/gun_pipe/gun_pipe_1.tscn"),
	preload("res://weapons/guns/gun_pipe/gun_pipe_2.tscn"),
	preload("res://weapons/guns/gun_pipe/gun_pipe_3.tscn"),
	preload("res://weapons/guns/gun_pipe/gun_pipe_4.tscn"),
	preload("res://weapons/guns/gun_pipe/gun_pipe_5.tscn"),
	preload("res://weapons/guns/gun_pipe/gun_pipe_6.tscn"),
	preload("res://weapons/guns/gun_pipe/gun_pipe_7.tscn"),
	preload("res://weapons/guns/gun_pipe/gun_pipe_8.tscn")
]
var cores_list = [
	preload("res://weapons/guns/gun_core/gun_core_0.tscn"),
	preload("res://weapons/guns/gun_core/gun_core_1.tscn"),
	preload("res://weapons/guns/gun_core/gun_core_2.tscn"),
	preload("res://weapons/guns/gun_core/gun_core_3.tscn")
]

var core_index = 0
var pipe_index = 0
var butt_index = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$SubViewportContainer/SubViewport/Node3D/Camera3D.global_position.y += (event.relative.y * 0.0001)
		$SubViewportContainer/SubViewport/Node3D/Camera3D.global_position.x += (event.relative.x * 0.0001)

func _on_texture_button_button_up() -> void:
	pipe_index += 1
	if pipe_index > pipes_list.size()-1:
		pipe_index = 0
	update_pipe()

func _on_texture_button_2_button_up() -> void:
	pass
	
func _on_texture_button_3_button_up() -> void:
	butt_index += 1
	if butt_index > butts_list.size()-1:
		butt_index = 0
	update_butt()
	
func _on_texture_button_4_button_up() -> void:
	update_handle()
	
func _on_texture_button_5_button_up() -> void:
	core_index += 1
	if core_index > cores_list.size()-1:
		core_index = 0
	update_core()

func _ready() -> void:
	update_core()
	update_butt()
	update_pipe()
	update_handle()

func update_pipe():
	for i in gun_core.pipe_snap.get_children():
		i.queue_free()
	if pipe_index > 0:
		gun_core.pipe_snap.add_child(pipes_list[pipe_index].instantiate())
		var tween = get_tree().create_tween()
		tween.tween_property(
			$SubViewportContainer/SubViewport/Node3D/Camera3D,
			"fov",
			85.5 + (pipe_index * 4),
			0.2
		).set_trans(Tween.TRANS_QUAD)
		tween.play()

func update_butt():
	for i in gun_core.butt_snap.get_children():
		i.queue_free()
	if butt_index > 0:
		gun_core.butt_snap.add_child(butts_list[butt_index].instantiate())

func update_core():
	for i in core_snap.get_children():
		i.queue_free()
	
	var core = cores_list[core_index].instantiate()
	core.name = "GunCore"
	core_snap.add_child(core)
	gun_core = core
	
	update_butt()
	update_pipe()
	update_handle()

func update_all_parts():
	update_butt()
	update_pipe()
	update_handle()
	update_core()

func randomize_all_parts():
	core_index = randi_range(0, cores_list.size()-1)
	pipe_index = randi_range(0, pipes_list.size()-1)
	butt_index = randi_range(0, butts_list.size()-1)

func update_handle():
	gun_core.handle_snap.add_child(load("res://weapons/guns/gun_handle/gun_handle_0.tscn").instantiate())

func _on_button_2_button_up() -> void:
	randomize_all_parts()
	update_all_parts()
