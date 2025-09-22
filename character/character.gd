extends CharacterBody3D
class_name Character

@onready var _body: Node3D = $Body
@onready var _stats: CharacterStats = $Stats
@onready var _camera: Camera3D = $CameraOffset/Camera
@onready var _camera_offset: Node3D = $CameraOffset

@onready var _crouched_collision: CollisionShape3D = $CrouchedCollision
@onready var _normal_collision: CollisionShape3D = $NormalCollision

@onready var _verifier_0: RayCast3D = $Verifiers/Verifier0
@onready var _verifier_1: RayCast3D = $Verifiers/Verifier1
@onready var _verifier_2: RayCast3D = $Verifiers/Verifier2
@onready var _verifier_3: RayCast3D = $Verifiers/Verifier3
@onready var _verifier_4: RayCast3D = $Verifiers/Verifier4

var speed_multiplier: float = 1.0

var crouching: bool = false
var is_spling: bool = false
var is_idle: bool = true

var can_rise: bool = false
var rise_0: bool = false
var rise_1: bool = false
var rise_2: bool = false
var rise_3: bool = false

var last_position: Vector3 = Vector3.ZERO
var last_rotation: Vector3 = Vector3.ZERO

var idle_cooldown_to_reload_stamina: float = 2.0
var reloading_stamina: bool = false

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	if not Globals.world_data_dictionary.first_read:
		global_position = Globals.world_data_dictionary.player_position
		global_rotation = Globals.world_data_dictionary.player_rotation
		_camera.global_rotation = Globals.world_data_dictionary.player_camera_rotation
	Globals.hide_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if Globals.on_menu: return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Globals.game_data_dictionary.mouse_sensibility)
		_camera_offset.rotate_x(-event.relative.y * Globals.game_data_dictionary.mouse_sensibility)
		_camera_offset.rotation.x = clamp(_camera_offset.rotation.x, -1.2, 1.2)

func _physics_process(_delta: float) -> void:
	if not Globals.on_menu:
		rise_0 = _verifier_0.is_colliding()
		rise_1 = _verifier_1.is_colliding()
		rise_2 = _verifier_2.is_colliding()
		rise_3 = _verifier_3.is_colliding()
		_movement_behavior(_delta)
		_actions_behavior()
		_stamina_behavior(_delta)
		_thirst_behavior()
		_hunger_behavior()
	_gravity(_delta)
	
	move_and_slide()
	
	if last_position != global_position or last_rotation != global_rotation:
		last_position = global_position
		last_rotation = global_rotation
		save_data()

func _movement_behavior(_delta: float) -> void:
	var _direction_input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var _direction: Vector3 = (transform.basis * Vector3(_direction_input.x, 0, _direction_input.y)).normalized()
	if _direction:
		velocity.x = _direction.x * _stats.movement_speed * speed_multiplier
		velocity.z = _direction.z * _stats.movement_speed * speed_multiplier
		
		if is_spling:
			_stats.update_stat("stamina", "-", 0.05)
		else:
			_stats.update_stat("stamina", "-", 0.02)
	else:
		velocity.x = move_toward(velocity.x, 0, _stats.movement_speed)
		velocity.z = move_toward(velocity.z, 0, _stats.movement_speed)

func _actions_behavior() -> void:
	if Globals.game_data_dictionary.autojump == 1:
		_autojump()
	
	_rise_behavior()
	if Input.is_action_just_pressed("ui_rise") and can_rise:
		_rise()
	elif Input.is_action_just_pressed("ui_jump"):
		_jump()
	
	if Input.is_action_pressed("ui_crouch"):
		_crouch()
	else:
		_uncrouch()

func _rise_behavior() -> void:
	if not _verifier_2.is_colliding() and _verifier_1.is_colliding() and _verifier_3.is_colliding():
		can_rise = true
	else:
		if can_rise:
			can_rise = false
func _rise() -> void:
	if _stats.stamina <= 3: return
	global_position.x = move_toward(global_position.x, _verifier_3.get_collision_point().x, 5)
	global_position.y = move_toward(global_position.y, _verifier_3.get_collision_point().y - 0.5, 5)
	global_position.z = move_toward(global_position.z, _verifier_3.get_collision_point().z, 5)
	_stats.update_stat("stamina", "-", 3.0)

func _jump() -> void:
	if is_on_floor():
		velocity.y += _stats.jump_force
		_stats.update_stat("stamina", "-", 1.0)
func _autojump() -> void:
	if is_on_floor():
		if _verifier_0.is_colliding() and not _verifier_1.is_colliding():
			velocity.y += _stats.jump_force / 2
			_stats.update_stat("stamina", "-", 0.25)

func _crouch() -> void:
	if not crouching:
		crouching = true
		_verifier_4.enabled = true
		_body.scale.y = 0.65
		_camera_offset.global_position.y = 0.936
		_crouched_collision.disabled = false
		_normal_collision.disabled = true
		speed_multiplier = 0.5
func _uncrouch() -> void:
	if crouching:
		if _verifier_4.is_colliding(): return
		crouching = false
		_body.scale.y = 1.0
		_verifier_4.enabled = false
		_camera_offset.global_position.y = 1.67
		_crouched_collision.disabled = true
		_normal_collision.disabled = false

func _hunger_behavior() -> void:
	_stats.update_stat("hunger", "-", 0.0005)

func _thirst_behavior() -> void:
	if reloading_stamina:
		_stats.update_stat("thirst", "-", 0.003)
	else:
		_stats.update_stat("thirst", "-", 0.001)

func _stamina_behavior(_delta: float) -> void:
	if velocity.x or velocity.z:
		if is_idle:
			is_idle = false
	else:
		if not is_idle:
			is_idle = true

	if is_idle:
		if reloading_stamina:
			_stats.update_stat("stamina", "+", 1)
		else:
			idle_cooldown_to_reload_stamina -= _delta
			if idle_cooldown_to_reload_stamina < 0:
				reloading_stamina = true
				idle_cooldown_to_reload_stamina = 2.0
	else:
		if reloading_stamina:
			reloading_stamina = false
			idle_cooldown_to_reload_stamina = 2.0
	
	if _stats.stamina == 0:
		speed_multiplier = 0.2
		if is_spling:
			is_spling = false
	else:
		if Input.is_action_pressed("ui_spling"):
			speed_multiplier = 1.5
			if not is_spling:
				is_spling = true
		else:
			speed_multiplier = 1.0
			if is_spling:
				is_spling = false

func _gravity(_delta: float) -> void:
	velocity.y -= ProjectSettings.get("physics/3d/default_gravity") * _delta * 5

func save_data() -> void:
	Globals.world_data_dictionary.player_position = global_position
	Globals.world_data_dictionary.player_rotation = global_rotation
	Globals.world_data_dictionary.player_camera_rotation = _camera.global_rotation
