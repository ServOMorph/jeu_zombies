class_name PlayerController
extends CharacterBody3D

const PLAYER_VITALS := preload("res://player/player_vitals.gd")
const WEAPON_VISUAL_RESTING_Z := -0.62
const WEAPON_VISUAL_CLOSEST_Z := 0.06
const WEAPON_VISUAL_FRONT_OFFSET := 0.355
const WEAPON_VISUAL_CLEARANCE := 0.04

@export_category("Déplacement")
@export var walk_speed := 5.5
@export var sprint_speed := 8.0
@export var crouch_speed := 2.5
@export var acceleration := 28.0
@export var deceleration := 34.0
@export var gravity := 24.0
@export var jump_velocity := 7.5
@export_range(0.05, 0.6, 0.01) var max_step_height := 0.35
@export_range(1.0, 60.0, 0.5) var max_floor_angle_degrees := 46.0

@export_category("Vision")
@export_range(0.0001, 0.01, 0.0001) var mouse_sensitivity := 0.0025
@export_range(10.0, 89.0, 1.0) var vertical_look_limit_degrees := 80.0
@export_range(60.0, 110.0, 1.0) var sprint_fov := 82.0
@export_range(1.0, 30.0, 0.5) var fov_transition_speed := 10.0
@export_range(0.1, 5.0, 0.1) var recoil_degrees := 0.7
@export_range(1.0, 40.0, 0.5) var recoil_recovery_degrees_per_second := 9.0
@export_range(1.0, 40.0, 0.5) var weapon_extension_speed := 8.0

@export_category("Posture")
@export_range(0.8, 2.4, 0.05) var standing_height := 1.8
@export_range(0.7, 1.7, 0.05) var crouching_height := 1.1

@export_category("Santé et endurance")
@export var max_health := 100.0
@export var damage_invulnerability_seconds := 0.2
@export var health_regeneration_delay_seconds := 4.0
@export var health_regeneration_per_second := 10.0
@export var max_stamina := 100.0
@export var stamina_drain_per_second := 35.0
@export var stamina_regeneration_per_second := 28.0
@export_range(1.0, 100.0, 1.0) var stamina_reactivation_threshold := 25.0

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var weapon_visual_root: Node3D = $Head/Camera3D/WeaponVisualRoot
@onready var weapon_obstacle_probe: RayCast3D = $Head/Camera3D/WeaponObstacleProbe
@onready var interaction_controller = $Head/Camera3D/InteractionController
@onready var weapon_controller = $WeaponController

var _standing_shape: CapsuleShape3D
var _standing_collision_position := Vector3.ZERO
var _is_crouching := false
var _base_fov := 75.0
var _recoil_remaining := 0.0
var is_sprinting := false
var vitals = PLAYER_VITALS.new()


func _ready() -> void:
	add_to_group("player")
	vitals.configure(
		max_health,
		damage_invulnerability_seconds,
		health_regeneration_delay_seconds,
		health_regeneration_per_second,
		max_stamina,
		stamina_drain_per_second,
		stamina_regeneration_per_second,
		stamina_reactivation_threshold
	)
	vitals.died.connect(_on_died)
	_standing_shape = (collision_shape.shape as CapsuleShape3D).duplicate() as CapsuleShape3D
	_standing_shape.height = standing_height
	_standing_collision_position = Vector3(0.0, standing_height * 0.5, 0.0)
	floor_max_angle = deg_to_rad(max_floor_angle_degrees)
	floor_stop_on_slope = true
	_apply_stance(false)
	_base_fov = camera.fov
	weapon_obstacle_probe.add_exception(self)
	interaction_controller.configure(self)
	weapon_controller.shot_fired.connect(_on_shot_fired)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	_recover_recoil(delta)
	if vitals.is_dead:
		velocity = Vector3.ZERO
		is_sprinting = false
		_update_camera_fov(delta)
		_update_weapon_visual(delta)
		return
	weapon_controller.tick(delta)

	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump") and not _is_crouching:
		velocity.y = jump_velocity

	_update_stance()
	var movement_input := Input.get_vector(
		"move_left", "move_right", "move_forward", "move_backward"
	)
	var movement_direction := (
		global_transform.basis * Vector3(movement_input.x, 0.0, movement_input.y)
	).normalized()
	is_sprinting = (
		not movement_direction.is_zero_approx()
		and Input.is_action_pressed("sprint")
		and vitals.can_sprint()
	)
	vitals.update(delta, is_sprinting)
	var target_speed := select_speed(
		_is_crouching,
		is_sprinting,
		walk_speed,
		sprint_speed,
		crouch_speed
	)
	var horizontal_velocity := resolve_horizontal_velocity(
		Vector3(velocity.x, 0.0, velocity.z),
		movement_direction,
		target_speed,
		acceleration,
		deceleration,
		delta
	)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	var horizontal_motion := horizontal_velocity * delta
	var was_on_floor := is_on_floor()
	move_and_slide()
	if was_on_floor:
		_try_step_up(horizontal_motion)
	_update_camera_fov(delta)
	if Input.is_action_pressed("fire") and not weapon_controller.is_knife_active():
		weapon_controller.try_fire(camera.global_position, -camera.global_transform.basis.z)
	elif Input.is_action_just_pressed("fire"):
		weapon_controller.try_melee(camera.global_position, -camera.global_transform.basis.z)
	if Input.is_action_just_pressed("reload"):
		weapon_controller.start_reload()
	if Input.is_action_just_pressed("weapon_next"):
		weapon_controller.switch_next()
	if Input.is_action_just_pressed("weapon_previous"):
		weapon_controller.switch_next()
	if Input.is_action_just_pressed("melee"):
		weapon_controller.select_knife()
		weapon_controller.try_melee(camera.global_position, -camera.global_transform.basis.z)
	_update_weapon_visual(delta)


func receive_damage(amount: float) -> bool:
	return vitals.apply_damage(amount)


func _on_died() -> void:
	velocity = Vector3.ZERO
	weapon_controller.disable_combat()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if GameSession.state == GameSession.State.PLAYING or GameSession.state == GameSession.State.PAUSED:
		GameSession.finish_session(GameSession.State.DEFEAT)


func get_horizontal_speed() -> float:
	return Vector2(velocity.x, velocity.z).length()


func _update_camera_fov(delta: float) -> void:
	var target_fov := sprint_fov if is_sprinting else _base_fov
	camera.fov = move_toward(camera.fov, target_fov, fov_transition_speed * delta)


func _update_weapon_visual(delta: float) -> void:
	var obstacle_distance := 0.0
	if weapon_obstacle_probe.is_colliding():
		obstacle_distance = camera.global_position.distance_to(
			weapon_obstacle_probe.get_collision_point()
		)
	weapon_visual_root.visible = should_show_weapon_visual(
		obstacle_distance,
		WEAPON_VISUAL_FRONT_OFFSET,
		WEAPON_VISUAL_CLEARANCE,
		WEAPON_VISUAL_CLOSEST_Z
	)
	if not weapon_visual_root.visible:
		return
	var target_z := resolve_weapon_visual_z(
		obstacle_distance,
		WEAPON_VISUAL_RESTING_Z,
		WEAPON_VISUAL_FRONT_OFFSET,
		WEAPON_VISUAL_CLEARANCE,
		WEAPON_VISUAL_CLOSEST_Z
	)
	if target_z > weapon_visual_root.position.z:
		weapon_visual_root.position.z = target_z
	else:
		weapon_visual_root.position.z = move_toward(
			weapon_visual_root.position.z,
			target_z,
			weapon_extension_speed * delta
		)


func _on_shot_fired(_weapon_name: String) -> void:
	var recoil := deg_to_rad(recoil_degrees)
	var look_limit := deg_to_rad(vertical_look_limit_degrees)
	head.rotation.x = maxf(head.rotation.x - recoil, -look_limit)
	_recoil_remaining += recoil


func _recover_recoil(delta: float) -> void:
	if _recoil_remaining <= 0.0:
		return
	var recovery := minf(
		_recoil_remaining,
		deg_to_rad(recoil_recovery_degrees_per_second) * delta
	)
	head.rotation.x += recovery
	_recoil_remaining -= recovery


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		var look_limit := deg_to_rad(vertical_look_limit_degrees)
		head.rotation.x = clamp(head.rotation.x, -look_limit, look_limit)
		get_viewport().set_input_as_handled()


func _update_stance() -> void:
	if Input.is_action_pressed("crouch"):
		_apply_stance(true)
	elif _is_crouching and _can_stand():
		_apply_stance(false)


func _can_stand() -> bool:
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = _standing_shape
	query.transform = global_transform * Transform3D(
		Basis.IDENTITY, _standing_collision_position
	)
	query.collision_mask = collision_mask
	query.exclude = [get_rid()]
	return get_world_3d().direct_space_state.intersect_shape(query, 1).is_empty()


func _apply_stance(should_crouch: bool) -> void:
	var shape := collision_shape.shape as CapsuleShape3D
	var target_height := crouching_height if should_crouch else standing_height
	shape.height = target_height
	collision_shape.position.y = target_height * 0.5
	head.position.y = target_height - 0.25
	_is_crouching = should_crouch


func _try_step_up(horizontal_motion: Vector3) -> void:
	if not is_on_wall() or horizontal_motion.length_squared() == 0.0:
		return

	var step_offset := Vector3.UP * max_step_height
	if test_move(global_transform, step_offset):
		return
	var elevated_transform := global_transform.translated(step_offset)
	if test_move(elevated_transform, horizontal_motion):
		return
	global_transform = elevated_transform
	move_and_collide(horizontal_motion)


static func select_speed(
	is_crouching: bool,
	is_sprinting: bool,
	walk: float,
	sprint: float,
	crouch: float
) -> float:
	if is_crouching:
		return crouch
	if is_sprinting:
		return sprint
	return walk


static func resolve_horizontal_velocity(
	current: Vector3,
	direction: Vector3,
	target_speed: float,
	acceleration_value: float,
	deceleration_value: float,
	delta: float
) -> Vector3:
	var target := direction * target_speed
	var rate := acceleration_value if not direction.is_zero_approx() else deceleration_value
	return current.move_toward(target, rate * delta)


static func is_slope_walkable(slope_angle_degrees: float, max_angle_degrees: float) -> bool:
	return slope_angle_degrees <= max_angle_degrees


static func resolve_weapon_visual_z(
	obstacle_distance: float,
	resting_z: float,
	front_offset: float,
	clearance: float,
	closest_z: float
) -> float:
	if obstacle_distance <= 0.0:
		return resting_z
	var target_z := -(obstacle_distance - clearance - front_offset)
	return clampf(target_z, resting_z, closest_z)


static func should_show_weapon_visual(
	obstacle_distance: float,
	front_offset: float,
	clearance: float,
	closest_z: float
) -> bool:
	if obstacle_distance <= 0.0:
		return true
	return -(obstacle_distance - clearance - front_offset) <= closest_z
