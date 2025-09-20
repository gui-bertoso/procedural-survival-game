extends CharacterBody3D

var speed_multiplier = 1.0

var crouching = false
var is_spling = false
var is_idle = true

var can_rise = false
var climb_0 = false
var climb_1 = false
var climb_2 = false
var climb_3 = false

var last_pos = Vector3(0, 0, 0)
var last_rot = Vector3(0, 0, 0)

var idle_cooldown_to_reload_stamina = 2.0
var reloading_stamina = false

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	if not Globals.world_data_dictionary.first_read:
		global_position = Globals.world_data_dictionary.player_position
		global_rotation = Globals.world_data_dictionary.player_rotation
		$CameraOffset/Camera.global_rotation = Globals.world_data_dictionary.player_camera_rotation
	Globals.hide_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if Globals.on_menu: return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Globals.game_data_dictionary.mouse_sensibility)
		$CameraOffset.rotate_x(-event.relative.y * Globals.game_data_dictionary.mouse_sensibility)
		$CameraOffset.rotation.x = clamp($CameraOffset.rotation.x, -1.2, 1.2)
		print("HHHH: " + str($CameraOffset.rotation.x))
func _physics_process(_delta: float) -> void:
	if not Globals.on_menu:
		climb_0 = $Verifiers/JumpVerifier0.is_colliding()
		climb_1 = $Verifiers/JumpVerifier1.is_colliding()
		climb_2 = $Verifiers/JumpVerifier2.is_colliding()
		climb_3 = $Verifiers/JumpVerifier3.is_colliding()
		_movement_behavior(_delta)
		_actions_behavior()
		_stamina_behavior(_delta)
		_thirst_behavior()
		_hunger_behavior()
	_gravity(_delta)
	
	move_and_slide()
	
	if last_pos != global_position or last_rot != global_rotation:
		last_pos = global_position
		last_rot = global_rotation
		save_data()

func _movement_behavior(_delta: float) -> void:
	var _direction_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var _direction = (transform.basis * Vector3(_direction_input.x, 0, _direction_input.y)).normalized()
	if _direction:
		velocity.x = _direction.x * $Stats.movement_speed * speed_multiplier
		velocity.z = _direction.z * $Stats.movement_speed * speed_multiplier
		
		if is_spling:
			$Stats.update_stat("stamina", "-", 0.05)
		else:
			$Stats.update_stat("stamina", "-", 0.02)
	else:
		velocity.x = move_toward(velocity.x, 0, $Stats.movement_speed)
		velocity.z = move_toward(velocity.z, 0, $Stats.movement_speed)

func _actions_behavior() -> void:
	_rise_behavior()
	if Globals.game_data_dictionary.autojump == 1:
		_autojump()
	if Input.is_action_just_pressed("ui_climb") and can_rise:
		_rise()
	elif Input.is_action_just_pressed("ui_jump"):
		_jump()
	if Input.is_action_pressed("ui_crouch"):
		_crouch()
	else:
		_uncrouch()

func _rise_behavior() -> void:
	if not $Verifiers/JumpVerifier2.is_colliding() and $Verifiers/JumpVerifier1.is_colliding() and $Verifiers/JumpVerifier3.is_colliding():
		can_rise = true
	else:
		if can_rise:
			can_rise = false

func _rise() -> void:
	if $Stats.stamina <= 3: return
	global_position.x = move_toward(global_position.x, $Verifiers/JumpVerifier3.get_collision_point().x, 5)
	global_position.y = move_toward(global_position.y, $Verifiers/JumpVerifier3.get_collision_point().y - 0.5, 5)
	global_position.z = move_toward(global_position.z, $Verifiers/JumpVerifier3.get_collision_point().z, 5)
	$Stats.update_stat("stamina", "-", 3.0)

func _hunger_behavior() -> void:
	$Stats.update_stat("hunger", "-", 0.0005)

func _thirst_behavior() -> void:
	if reloading_stamina:
		$Stats.update_stat("thirst", "-", 0.003)
	else:
		$Stats.update_stat("thirst", "-", 0.001)

func _stamina_behavior(_delta) -> void:
	if velocity.x or velocity.z:
		if is_idle:
			is_idle = false
	else:
		if not is_idle:
			is_idle = true

	if is_idle:
		if reloading_stamina:
			$Stats.update_stat("stamina", "+", 1)
		else:
			idle_cooldown_to_reload_stamina -= _delta
			if idle_cooldown_to_reload_stamina < 0:
				reloading_stamina = true
				idle_cooldown_to_reload_stamina = 2.0
	else:
		if reloading_stamina:
			reloading_stamina = false
			idle_cooldown_to_reload_stamina = 2.0
	
	if $Stats.stamina == 0:
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

func _gravity(_delta) -> void:
	velocity.y -= ProjectSettings.get("physics/3d/default_gravity") * _delta * 5

func _autojump() -> void:
	if is_on_floor():
		if $Verifiers/JumpVerifier0.is_colliding() and not $Verifiers/JumpVerifier1.is_colliding():
			velocity.y += $Stats.jump_force / 2
			$Stats.update_stat("stamina", "-", 0.25)

func _jump() -> void:
	if is_on_floor():
		velocity.y += $Stats.jump_force
		$Stats.update_stat("stamina", "-", 1.0)

func _crouch() -> void:
	if not crouching:
		crouching = true
		$Verifiers/UncrouchVerifier.enabled = true
		$Body.scale.y = 0.65
		$CameraOffset.global_position.y = 0.936
		$CrouchedCollision.disabled = false
		$NormalCollision.disabled = true
		speed_multiplier = 0.5

func _uncrouch() -> void:
	if crouching:
		if $Verifiers/UncrouchVerifier.is_colliding(): return
		crouching = false
		$Body.scale.y = 1.0
		$Verifiers/UncrouchVerifier.enabled = false
		$CameraOffset.global_position.y = 1.67
		$CrouchedCollision.disabled = true
		$NormalCollision.disabled = false

func save_data() -> void:
	Globals.world_data_dictionary.player_position = global_position
	Globals.world_data_dictionary.player_rotation = global_rotation
	Globals.world_data_dictionary.player_camera_rotation = $CameraOffset/Camera.global_rotation
