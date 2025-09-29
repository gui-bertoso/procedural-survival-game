extends CharacterBody3D
class_name Animal

enum State{
	none,
	idle,
	wander,
	chase,
	attack_0,
	attack_1,
	attack_2,
	rescue
}

enum AnimalBehavior{
	passive,
	ofensive,
	neutral
}

@onready var stats: StatsComponent = $Stats
@onready var animation: AnimationPlayer = $Body/Animation

@export var min_time_to_wander: float = 1.0
@export var max_time_to_wander: float = 2.0

@export var min_wandering_time: float = 0.5
@export var max_wandering_time: float = 3.0

@export var animal_behavior: AnimalBehavior

var current_state: State = State.none

var time_to_wander: float = 0.0
var wander_cooldown: float = 0.0
var wandering_time: float = 0.0

var time_to_wander_count: float = 0.0
var wander_cooldown_count: float = 0.0
var wandering_time_count: float = 0.0

var wander_direction: Vector3 = Vector3.ZERO

var chance_to_wander: int = 10

var player_reference: Character = null

var wander_direction_modify_chance: int = 210

func _process(delta: float) -> void:
	update_state(delta)
	animate()
	
	gravity(delta)
	if velocity:
		var target_position: Vector3 = global_position + velocity
		look_at(Vector3(target_position.x, global_position.y, target_position.z))
		move_and_slide()

func _physics_process(_delta: float) -> void:
	apply_state()

func animate() -> void:
	match current_state:
		State.none:
			current_state = State.idle
		State.idle:
			if not animation.is_playing() or (animation.is_playing() and animation.current_animation != "idle"):
				animation.play("idle") 
		State.wander:
			if not animation.is_playing() or (animation.is_playing() and animation.current_animation != "walk"):
				animation.play("walk") 
		State.chase:
			if not animation.is_playing() or (animation.is_playing() and animation.current_animation != "spring"):
				animation.play("spring") 
		State.attack_0:
			pass
		State.attack_1:
			pass
		State.attack_2:
			pass
		State.rescue:
			pass

func randomize_time_to_wander() -> void:
	time_to_wander = randf_range(min_time_to_wander, max_time_to_wander)
func randomize_wandering_time() -> void:
	wandering_time = randf_range(min_wandering_time, max_wandering_time)
func randomize_wander_direction() -> void:
	wander_direction.x = randf_range(-1, 1)
	wander_direction.z = randf_range(-1, 1)
	wander_direction = wander_direction.normalized()

func update_state(delta: float) -> void:
	match current_state:
		State.idle:
			if not player_reference:
				if randi_range(0, chance_to_wander):
					wander_cooldown_count += delta
					if wander_cooldown_count >= time_to_wander:
						wander_cooldown_count = 0
						randomize_time_to_wander()
						randomize_wandering_time()
						randomize_wander_direction()
						current_state = State.wander
				return
			if animal_behavior == AnimalBehavior.ofensive:
				current_state = State.chase
			elif animal_behavior == AnimalBehavior.passive:
				current_state = State.rescue
		State.wander:
			if wandering_time > 0:
				wandering_time -= delta
				if randi_range(0, wander_direction_modify_chance) == 0:
					randomize_wander_direction()
				return
			current_state = State.idle
		State.chase:
			pass
		State.attack_0:
			pass
		State.attack_1:
			pass
		State.attack_2:
			pass
		State.rescue:
			pass

func apply_state() -> void:
	match current_state:
		State.idle:
			velocity.x = move_toward(velocity.x, 0.0, stats.movement_speed)
			velocity.z = move_toward(velocity.z, 0.0, stats.movement_speed)
		State.wander:
			velocity.x = wander_direction.x * stats.movement_speed / 2
			velocity.z = wander_direction.z * stats.movement_speed / 2
		State.chase:
			pass
		State.attack_0:
			pass
		State.attack_1:
			pass
		State.attack_2:
			pass
		State.rescue:
			pass

func gravity(delta: float) -> void:
	velocity.y -= ProjectSettings.get("physics/3d/default_gravity") * delta * 5
