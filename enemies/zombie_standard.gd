class_name ZombieStandard
extends CharacterBody3D

const MIXAMO_ANIMATION_SOURCES: Dictionary[StringName, PackedScene] = {
	&"idle": preload("res://assets/characters/enemies/mixamo/zombie idle.fbx"),
	&"walk": preload("res://assets/characters/enemies/mixamo/zombie walk.fbx"),
	&"run": preload("res://assets/characters/enemies/mixamo/zombie run.fbx"),
	&"attack": preload("res://assets/characters/enemies/mixamo/zombie attack.fbx"),
	&"death": preload("res://assets/characters/enemies/mixamo/zombie death.fbx"),
	&"dying": preload("res://assets/characters/enemies/mixamo/zombie dying.fbx"),
	&"scream": preload("res://assets/characters/enemies/mixamo/zombie scream.fbx"),
}
const MIXAMO_LOOPED_ANIMATIONS: Array[StringName] = [&"idle", &"walk", &"run"]

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
@export_range(0.1, 20.0, 0.1) var turn_speed_radians := 10.0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var body_visual: Node3D = $BodyVisual
@onready var animation_player: AnimationPlayer = _find_animation_player(body_visual)

var state: State = State.INACTIVE
var health := 0.0
var _target: Node3D
var _spawn_remaining := 0.0
var _hurt_remaining := 0.0
var _death_remaining := 0.0
var _attack_cooldown_remaining := 0.0
var _attack_windup_remaining := 0.0
var _attack_pending := false
var _path_refresh_remaining := 0.0
var _reward_has_been_granted := false
var _base_definition: ZombieDefinition


func _ready() -> void:
	add_to_group("zombies")
	_install_mixamo_animations()
	if definition == null:
		definition = ZombieDefinition.new()
	_base_definition = definition
	if start_active:
		activate()
	else:
		deactivate()


func activate(target: Node3D = null, definition_override: ZombieDefinition = null) -> void:
	var active_definition := definition_override if definition_override != null else _base_definition
	if active_definition == null:
		active_definition = definition
	definition = active_definition
	if definition == null:
		definition = ZombieDefinition.new()
	_target = target
	health = definition.max_health
	_spawn_remaining = spawn_delay_seconds
	_hurt_remaining = 0.0
	_death_remaining = 0.0
	_attack_cooldown_remaining = 0.0
	_attack_windup_remaining = 0.0
	_attack_pending = false
	_path_refresh_remaining = 0.0
	_reward_has_been_granted = false
	velocity = Vector3.ZERO
	_attack_windup_remaining = 0.0
	_attack_pending = false
	visible = true
	if collision_shape != null:
		collision_shape.disabled = false
	set_physics_process(true)
	_set_state(State.SPAWNING)
	health_changed.emit(health, definition.max_health)


func create_wave_definition(health_multiplier: float) -> ZombieDefinition:
	var source := _base_definition if _base_definition != null else definition
	var scaled_definition := source.duplicate() as ZombieDefinition
	scaled_definition.max_health = source.max_health * maxf(health_multiplier, 0.1)
	return scaled_definition


func deactivate() -> void:
	velocity = Vector3.ZERO
	visible = false
	if collision_shape != null:
		collision_shape.set_deferred("disabled", true)
	_set_state(State.INACTIVE)
	set_physics_process(false)


func request_navigation_repath() -> void:
	_path_refresh_remaining = 0.0
	if navigation_agent != null and is_instance_valid(_target):
		navigation_agent.target_position = _target.global_position


func receive_damage(amount: float) -> bool:
	if amount <= 0.0 or state == State.INACTIVE or state == State.DYING:
		return false
	health = maxf(0.0, health - amount)
	if is_inside_tree():
		_spawn_combat_burst(global_position + Vector3.UP * 1.0, Color(1.0, 0.34, 0.08, 1.0), 0.32, 0.16)
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
		_play_animation(&"mixamo/idle")
		move_and_slide()
		return

	var distance := global_position.distance_to(_target.global_position)
	if is_attack_valid(distance, definition.attack_range_meters, _has_clear_attack_line()):
		_try_attack(delta)
		move_and_slide()
		return

	_attack_pending = false
	_attack_windup_remaining = 0.0
	_set_state(State.CHASING)
	_move_toward_target(delta)
	move_and_slide()


func _move_toward_target(delta: float) -> void:
	_path_refresh_remaining -= delta
	if should_refresh_path(_path_refresh_remaining, definition.path_refresh_seconds):
		navigation_agent.target_position = _target.global_position
		_path_refresh_remaining = definition.path_refresh_seconds
	var next_position := _target.global_position
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) > 0:
		if navigation_agent.is_navigation_finished():
			if is_target_within_reach(
				global_position.distance_to(_target.global_position),
				definition.attack_range_meters,
			):
				_stop_horizontal_motion()
				return
		else:
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
	_face_movement_direction(delta)


func _face_movement_direction(delta: float) -> void:
	var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)
	if horizontal_velocity.length_squared() == 0.0:
		return
	rotation.y = rotate_toward(
		rotation.y,
		horizontal_yaw_for_direction(horizontal_velocity),
		turn_speed_radians * delta,
	)


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
	if _target == null:
		return
	if not _attack_pending:
		if _attack_cooldown_remaining > 0.0:
			_set_state(State.CHASING)
			return
		_attack_pending = true
		_attack_windup_remaining = definition.attack_hit_delay_seconds
		_set_state(State.ATTACKING)
		_play_animation(_animation_name_for_state(State.ATTACKING), true)
		return
	_attack_windup_remaining = advance_attack_windup(_attack_windup_remaining, delta)
	if _attack_windup_remaining > 0.0:
		return
	_attack_pending = false
	var distance := global_position.distance_to(_target.global_position)
	if not is_attack_valid(distance, definition.attack_range_meters, _has_clear_attack_line()):
		_set_state(State.CHASING)
		return
	if _target.has_method("receive_damage") and _target.call("receive_damage", definition.attack_damage):
		if _target is Node3D:
			_spawn_combat_burst((_target as Node3D).global_position + Vector3.UP, Color(0.9, 0.03, 0.02, 1.0), 0.42, 0.2)
		attacked.emit(_target, definition.attack_damage)
	_attack_cooldown_remaining = definition.attack_cooldown_seconds
	_set_state(State.CHASING)


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
	if is_inside_tree():
		_spawn_combat_burst(global_position + Vector3.UP, Color(0.48, 0.95, 0.22, 1.0), 0.9, 0.34)
	_death_remaining = definition.death_feedback_seconds
	_set_state(State.DYING)
	if collision_shape != null:
		collision_shape.set_deferred("disabled", true)
	if not _reward_has_been_granted:
		_reward_has_been_granted = true
		reward_granted.emit(definition.credit_reward)
	died.emit()


func _spawn_combat_burst(world_position: Vector3, color: Color, radius: float, duration: float) -> void:
	if not is_inside_tree() or get_tree().current_scene == null:
		return
	var burst := MeshInstance3D.new()
	burst.name = "CombatVfxBurst"
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	burst.mesh = mesh
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 2.4
	burst.material_override = material
	get_tree().current_scene.add_child(burst)
	burst.global_position = world_position
	burst.scale = Vector3.ONE * 0.35
	var tween := burst.create_tween()
	tween.tween_property(burst, "scale", Vector3.ONE * 1.35, duration)
	tween.parallel().tween_property(material, "albedo_color", Color(color.r, color.g, color.b, 0.0), duration)
	tween.finished.connect(burst.queue_free)


func _set_state(new_state: State) -> void:
	if state == new_state:
		return
	state = new_state
	_play_state_animation(new_state)
	state_changed.emit(state)


func _find_animation_player(root: Node) -> AnimationPlayer:
	if root == null:
		return null
	return root.find_child("AnimationPlayer", true, false) as AnimationPlayer


func _install_mixamo_animations() -> void:
	if animation_player == null:
		return
	var library := AnimationLibrary.new()
	for animation_name: StringName in MIXAMO_ANIMATION_SOURCES:
		var source := MIXAMO_ANIMATION_SOURCES[animation_name].instantiate() as Node3D
		var source_player := _find_animation_player(source)
		var source_animation := source_player.get_animation(&"mixamo_com") if source_player != null else null
		if source_animation != null:
			var animation := source_animation.duplicate(true) as Animation
			configure_mixamo_animation(animation_name, animation)
			library.add_animation(animation_name, animation)
		source.free()
	if not library.get_animation_list().is_empty():
		animation_player.add_animation_library(&"mixamo", library)


func _play_state_animation(new_state: State) -> void:
	_play_animation(_animation_name_for_state(new_state))


func _play_animation(animation_name: StringName, restart := false) -> void:
	if animation_player == null or animation_name.is_empty() or not animation_player.has_animation(animation_name):
		return
	if restart or animation_player.current_animation != animation_name:
		animation_player.play(animation_name, 0.12)


static func configure_mixamo_animation(animation_name: StringName, animation: Animation) -> void:
	animation.loop_mode = Animation.LOOP_LINEAR if animation_name in MIXAMO_LOOPED_ANIMATIONS else Animation.LOOP_NONE
	for index in animation.get_track_count():
		if not is_mixamo_root_translation_track(animation.track_get_path(index), animation.track_get_type(index)):
			continue
		var first_position := animation.track_get_key_value(index, 0) as Vector3
		for key_index in animation.track_get_key_count(index):
			var position := animation.track_get_key_value(index, key_index) as Vector3
			animation.track_set_key_value(index, key_index, Vector3(first_position.x, position.y, first_position.z))


static func is_mixamo_root_translation_track(track_path: NodePath, track_type: Animation.TrackType) -> bool:
	return track_type == Animation.TYPE_POSITION_3D and str(track_path).contains(":mixamorig_Hips")


static func _animation_name_for_state(new_state: State) -> StringName:
	match new_state:
		State.INACTIVE:
			return &"mixamo/dying"
		State.SPAWNING:
			return &"mixamo/scream"
		State.CHASING:
			return &"mixamo/run"
		State.ATTACKING:
			return &"mixamo/attack"
		State.HURT:
			return &"mixamo/scream"
		State.DYING:
			return &"mixamo/death"
	return &""


static func is_attack_valid(distance: float, attack_range: float, has_clear_line: bool) -> bool:
	return distance <= attack_range and has_clear_line


static func horizontal_yaw_for_direction(direction: Vector3) -> float:
	return atan2(-direction.x, -direction.z)


static func advance_attack_windup(remaining_seconds: float, delta: float) -> float:
	return maxf(0.0, remaining_seconds - delta)


static func should_refresh_path(remaining_seconds: float, refresh_seconds: float) -> bool:
	return remaining_seconds <= 0.0 and refresh_seconds > 0.0


static func is_target_within_reach(distance: float, attack_range: float) -> bool:
	return distance <= attack_range


static func resolve_vertical_velocity(
	current_velocity: float,
	on_floor: bool,
	gravity_acceleration: float,
	delta: float,
) -> float:
	return 0.0 if on_floor else current_velocity - gravity_acceleration * delta
