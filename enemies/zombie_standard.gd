class_name ZombieStandard
extends CharacterBody3D

signal state_changed(new_state: State)
signal health_changed(current_health: float, maximum_health: float)
signal attacked(target: Node, damage: float)
signal died
signal reward_granted(credits: int)

enum State {
	INACTIVE,
	SPAWNING,
	CHASING,
	ATTACKING,
	HURT,
	DYING,
}

@export var definition: ZombieDefinition
@export var start_active := true
@export_range(0.0, 5.0, 0.05) var spawn_delay_seconds := 0.45
@export_range(0.0, 3.0, 0.05) var hurt_feedback_seconds := 0.16
@export_flags_3d_physics var attack_collision_mask := 1

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var body_visual: MeshInstance3D = $BodyVisual

var state: State = State.INACTIVE
var health := 0.0
var _target: Node3D
var _spawn_remaining := 0.0
var _hurt_remaining := 0.0
var _death_remaining := 0.0
var _attack_cooldown_remaining := 0.0
var _path_refresh_remaining := 0.0
var _reward_has_been_granted := false
var _body_material: StandardMaterial3D


func _ready() -> void:
	add_to_group("zombies")
	_body_material = StandardMaterial3D.new()
	_body_material.albedo_color = Color.WHITE
	_body_material.roughness = 0.85
	body_visual.material_override = _body_material
	if definition == null:
		definition = ZombieDefinition.new()
	if start_active:
		activate()
	else:
		deactivate()


func activate(target: Node3D = null) -> void:
	if definition == null:
		definition = ZombieDefinition.new()
	_target = target
	health = definition.max_health
	_spawn_remaining = spawn_delay_seconds
	_hurt_remaining = 0.0
	_death_remaining = 0.0
	_attack_cooldown_remaining = 0.0
	_path_refresh_remaining = 0.0
	_reward_has_been_granted = false
	velocity = Vector3.ZERO
	visible = true
	if collision_shape != null:
		collision_shape.disabled = false
	set_physics_process(true)
	_set_state(State.SPAWNING)
	health_changed.emit(health, definition.max_health)


func deactivate() -> void:
	velocity = Vector3.ZERO
	visible = false
	if collision_shape != null:
		collision_shape.set_deferred("disabled", true)
	_set_state(State.INACTIVE)
	set_physics_process(false)


func receive_damage(amount: float) -> bool:
	if amount <= 0.0 or state == State.INACTIVE or state == State.DYING:
		return false
	health = maxf(0.0, health - amount)
	health_changed.emit(health, definition.max_health)
	if health == 0.0:
		_die()
		return true
	_hurt_remaining = hurt_feedback_seconds
	_set_state(State.HURT)
	return true


func _physics_process(delta: float) -> void:
	if state == State.INACTIVE:
		return
	if state == State.DYING:
		_death_remaining = maxf(0.0, _death_remaining - delta)
		if _death_remaining == 0.0:
			deactivate()
		return

	_apply_gravity(delta)
	if state == State.SPAWNING:
		_stop_horizontal_motion()
		_spawn_remaining = maxf(0.0, _spawn_remaining - delta)
		if _spawn_remaining == 0.0:
			_set_state(State.CHASING)
		move_and_slide()
		return
	if state == State.HURT:
		_stop_horizontal_motion()
		_hurt_remaining = maxf(0.0, _hurt_remaining - delta)
		if _hurt_remaining == 0.0:
			_set_state(State.CHASING)
		move_and_slide()
		return
	_resolve_target()
	if _target == null:
		_stop_horizontal_motion()
		move_and_slide()
		return

	var distance := global_position.distance_to(_target.global_position)
	if is_attack_valid(distance, definition.attack_range_meters, _has_clear_attack_line()):
		_set_state(State.ATTACKING)
		_try_attack(delta)
		move_and_slide()
		return

	_set_state(State.CHASING)
	_move_toward_target(delta)
	move_and_slide()


func _move_toward_target(delta: float) -> void:
	_path_refresh_remaining -= delta
	if should_refresh_path(_path_refresh_remaining, definition.path_refresh_seconds):
		navigation_agent.target_position = _target.global_position
		_path_refresh_remaining = definition.path_refresh_seconds
	var next_position := _target.global_position
	if (
		NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) > 0
		and not navigation_agent.is_navigation_finished()
	):
		next_position = navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)
	direction.y = 0.0
	if direction.length_squared() == 0.0:
		_stop_horizontal_motion()
		return
	direction = direction.normalized()
	velocity.x = direction.x * definition.move_speed
	velocity.z = direction.z * definition.move_speed
	_separate_from_neighbours()


func _apply_gravity(delta: float) -> void:
	velocity.y = resolve_vertical_velocity(
		velocity.y,
		is_on_floor(),
		definition.gravity_acceleration,
		delta,
	)


func _stop_horizontal_motion() -> void:
	velocity.x = 0.0
	velocity.z = 0.0


func _try_attack(delta: float) -> void:
	_stop_horizontal_motion()
	_attack_cooldown_remaining = maxf(0.0, _attack_cooldown_remaining - delta)
	if _attack_cooldown_remaining > 0.0 or _target == null:
		return
	var distance := global_position.distance_to(_target.global_position)
	if not is_attack_valid(distance, definition.attack_range_meters, _has_clear_attack_line()):
		_set_state(State.CHASING)
		return
	if _target.has_method("receive_damage") and _target.call("receive_damage", definition.attack_damage):
		attacked.emit(_target, definition.attack_damage)
	_attack_cooldown_remaining = definition.attack_cooldown_seconds


func _resolve_target() -> void:
	if is_instance_valid(_target):
		return
	var players := get_tree().get_nodes_in_group("player")
	_target = players.front() as Node3D if not players.is_empty() else null


func _has_clear_attack_line() -> bool:
	if _target == null:
		return false
	var origin := global_position + Vector3.UP * 0.9
	var destination := _target.global_position + Vector3.UP * 0.9
	var query := PhysicsRayQueryParameters3D.create(origin, destination, attack_collision_mask)
	query.exclude = [get_rid()]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	return not hit.is_empty() and hit["collider"] == _target


func _separate_from_neighbours() -> void:
	var push := Vector3.ZERO
	for neighbour: Node in get_tree().get_nodes_in_group("zombies"):
		if neighbour == self or not neighbour is ZombieStandard:
			continue
		var offset := global_position - (neighbour as ZombieStandard).global_position
		offset.y = 0.0
		var distance := offset.length()
		if distance > 0.001 and distance < 0.7:
			push += offset.normalized() * (0.7 - distance)
	if not push.is_zero_approx():
		velocity += push.normalized() * 0.8


func _die() -> void:
	if state == State.DYING:
		return
	velocity = Vector3.ZERO
	_death_remaining = definition.death_feedback_seconds
	_set_state(State.DYING)
	if collision_shape != null:
		collision_shape.set_deferred("disabled", true)
	if not _reward_has_been_granted:
		_reward_has_been_granted = true
		reward_granted.emit(definition.credit_reward)
	died.emit()


func _set_state(new_state: State) -> void:
	if state == new_state:
		return
	state = new_state
	if body_visual != null:
		_body_material.albedo_color = _state_color(new_state)
	state_changed.emit(state)


static func is_attack_valid(distance: float, attack_range: float, has_clear_line: bool) -> bool:
	return distance <= attack_range and has_clear_line


static func should_refresh_path(remaining_seconds: float, refresh_seconds: float) -> bool:
	return remaining_seconds <= 0.0 and refresh_seconds > 0.0


static func resolve_vertical_velocity(
	current_velocity: float,
	on_floor: bool,
	gravity_acceleration: float,
	delta: float,
) -> float:
	return 0.0 if on_floor else current_velocity - gravity_acceleration * delta


static func _state_color(new_state: State) -> Color:
	match new_state:
		State.SPAWNING:
			return Color(0.65, 0.8, 0.95, 1.0)
		State.HURT:
			return Color(1.0, 0.45, 0.3, 1.0)
		State.DYING:
			return Color(0.22, 0.22, 0.22, 1.0)
		_:
			return Color.WHITE
