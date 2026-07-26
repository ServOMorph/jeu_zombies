class_name WeaponController
extends Node3D

const WEAPON_DEFINITION := preload("res://weapons/weapon_definition.gd")
const UPGRADE_DAMAGE_MULTIPLIER := 1.35

signal weapon_changed(weapon_name: String)
signal ammo_changed(magazine: int, reserve: int)
signal shot_fired(weapon_name: String)
signal hit_confirmed(damage: float)
signal impact_registered(position: Vector3, normal: Vector3)
signal melee_swung
signal reload_started
signal reload_finished
signal dry_fire

@export var initial_weapon: Resource
@export_range(0.1, 1.0, 0.01) var reload_speed_multiplier := 1.0
@export_category("Melee")
@export var melee_damage := 45.0
@export_range(0.5, 4.0, 0.1) var melee_range_meters := 2.0
@export_range(0.1, 2.0, 0.05) var melee_cooldown_seconds := 0.55

class WeaponState:
	var definition
	var magazine := 0
	var reserve := 0
	var cooldown_remaining := 0.0
	var reload_remaining := 0.0
	var upgraded := false

	func _init(new_definition) -> void:
		definition = new_definition
		magazine = new_definition.magazine_capacity
		reserve = new_definition.reserve_capacity

	func get_damage_multiplier() -> float:
		return WeaponController.UPGRADE_DAMAGE_MULTIPLIER if upgraded else 1.0


var active_slot := 0
var _slots: Array = [null, null]
var _knife_active := false
var _enabled := true
var _melee_cooldown_remaining := 0.0


func _ready() -> void:
	if initial_weapon != null:
		configure_slots(initial_weapon)


func configure_slots(first_weapon, second_weapon = null) -> void:
	_slots = [null, null]
	if first_weapon != null:
		_slots[0] = WeaponState.new(first_weapon)
	if second_weapon != null:
		_slots[1] = WeaponState.new(second_weapon)
	active_slot = 0
	_knife_active = false
	_enabled = true
	_melee_cooldown_remaining = 0.0
	_emit_current_state()


func set_slot(slot_index: int, definition) -> bool:
	if slot_index < 0 or slot_index > 1 or definition == null:
		return false
	_slots[slot_index] = WeaponState.new(definition)
	if _slots[active_slot] == null:
		active_slot = slot_index
		_knife_active = false
	_emit_current_state()
	return true


func tick(delta: float) -> void:
	_melee_cooldown_remaining = maxf(0.0, _melee_cooldown_remaining - delta)
	for state in _slots:
		if state == null:
			continue
		state.cooldown_remaining = maxf(0.0, state.cooldown_remaining - delta)
		if state.reload_remaining <= 0.0:
			continue
		state.reload_remaining = maxf(0.0, state.reload_remaining - delta)
		if state.reload_remaining == 0.0:
			_finish_reload(state)


func try_fire(origin: Vector3, direction: Vector3) -> bool:
	if not _enabled or _knife_active or is_reloading():
		return false
	var state = _current_state()
	if state == null or state.cooldown_remaining > 0.0:
		return false
	if state.magazine <= 0:
		dry_fire.emit()
		return false

	state.magazine -= 1
	state.cooldown_remaining = state.definition.fire_interval_seconds
	_emit_ammo(state)
	shot_fired.emit(state.definition.weapon_name)
	_perform_hitscan(origin, direction, state.definition, state.get_damage_multiplier())
	return true


func try_melee(origin: Vector3, direction: Vector3) -> bool:
	if not _enabled or not _knife_active or is_reloading() or _melee_cooldown_remaining > 0.0:
		return false
	_melee_cooldown_remaining = melee_cooldown_seconds
	melee_swung.emit()
	_perform_damage_ray(origin, direction.normalized(), melee_range_meters, melee_damage)
	return true


func start_reload() -> bool:
	if not _enabled or _knife_active or is_reloading():
		return false
	var state = _current_state()
	if state == null or state.magazine >= state.definition.magazine_capacity or state.reserve <= 0:
		return false
	state.reload_remaining = state.definition.reload_duration_seconds * reload_speed_multiplier
	reload_started.emit()
	return true


func equip_slot(slot_index: int) -> bool:
	if not _enabled or is_reloading() or slot_index < 0 or slot_index > 1:
		return false
	if _slots[slot_index] == null:
		return false
	active_slot = slot_index
	_knife_active = false
	_emit_current_state()
	return true


func switch_next() -> bool:
	return equip_slot(1 - active_slot)


func select_knife() -> void:
	if is_reloading():
		return
	_knife_active = true
	weapon_changed.emit("Couteau")


func disable_combat() -> void:
	_enabled = false
	_cancel_reload()


func is_reloading() -> bool:
	var state = _current_state()
	return state != null and state.reload_remaining > 0.0


func is_knife_active() -> bool:
	return _knife_active


func get_current_weapon_name() -> String:
	if _knife_active:
		return "Couteau"
	var state = _current_state()
	return "Aucun" if state == null else state.definition.weapon_name


func get_current_definition():
	if _knife_active:
		return null
	var state = _current_state()
	return null if state == null else state.definition


func get_current_ammo() -> Vector2i:
	var state = _current_state()
	if state == null or _knife_active:
		return Vector2i.ZERO
	return Vector2i(state.magazine, state.reserve)


func find_slot_for_definition(definition) -> int:
	for i in _slots.size():
		var state = _slots[i]
		if state != null and state.definition == definition:
			return i
	return -1


func first_free_slot() -> int:
	for i in _slots.size():
		if _slots[i] == null:
			return i
	return -1


func get_slot_ammo(slot_index: int) -> Vector2i:
	if slot_index < 0 or slot_index > 1 or _slots[slot_index] == null:
		return Vector2i.ZERO
	var state = _slots[slot_index]
	return Vector2i(state.magazine, state.reserve)


func is_slot_upgraded(slot_index: int) -> bool:
	if slot_index < 0 or slot_index > 1 or _slots[slot_index] == null:
		return false
	return _slots[slot_index].upgraded


func upgrade_slot(slot_index: int) -> bool:
	if slot_index < 0 or slot_index > 1 or _slots[slot_index] == null:
		return false
	if _slots[slot_index].upgraded:
		return false
	_slots[slot_index].upgraded = true
	return true


func is_slot_reserve_full(slot_index: int) -> bool:
	if slot_index < 0 or slot_index > 1 or _slots[slot_index] == null:
		return false
	var state = _slots[slot_index]
	return state.reserve >= state.definition.reserve_capacity


func refill_reserve(slot_index: int) -> bool:
	if slot_index < 0 or slot_index > 1 or _slots[slot_index] == null:
		return false
	var state = _slots[slot_index]
	if state.reserve >= state.definition.reserve_capacity:
		return false
	state.reserve = state.definition.reserve_capacity
	if slot_index == active_slot and not _knife_active:
		_emit_ammo(state)
	return true


func _current_state():
	return _slots[active_slot]


func _finish_reload(state) -> void:
	var needed: int = state.definition.magazine_capacity - state.magazine
	var transferred: int = mini(needed, state.reserve)
	state.magazine += transferred
	state.reserve -= transferred
	_emit_ammo(state)
	reload_finished.emit()


func _cancel_reload() -> void:
	var state = _current_state()
	if state != null:
		state.reload_remaining = 0.0


func _emit_current_state() -> void:
	weapon_changed.emit(get_current_weapon_name())
	var ammo := get_current_ammo()
	ammo_changed.emit(ammo.x, ammo.y)


func _emit_ammo(state) -> void:
	ammo_changed.emit(state.magazine, state.reserve)


func _perform_hitscan(origin: Vector3, direction: Vector3, definition, damage_multiplier: float = 1.0) -> void:
	if not is_inside_tree():
		return
	var world := get_world_3d()
	if world == null:
		return
	var max_damage_per_shot: float = definition.max_damage_per_shot * damage_multiplier
	var damage_budget: float = max_damage_per_shot if definition.max_damage_per_shot > 0.0 else INF
	var pellet_damage_full: float = definition.damage * damage_multiplier
	for i in maxi(1, definition.pellet_count):
		if damage_budget <= 0.0:
			return
		var shot_direction := _apply_spread(direction, definition.spread_degrees)
		var query := PhysicsRayQueryParameters3D.create(
			origin,
			origin + shot_direction * definition.range_meters
		)
		query.exclude = [get_parent().get_rid()]
		var result := world.direct_space_state.intersect_ray(query)
		if result.is_empty():
			continue
		var pellet_damage := minf(pellet_damage_full, damage_budget)
		damage_budget -= pellet_damage
		_perform_damage_result(result, pellet_damage)


func _perform_damage_ray(origin: Vector3, direction: Vector3, range_meters: float, damage: float) -> void:
	if not is_inside_tree():
		return
	var world := get_world_3d()
	if world == null:
		return
	var query := PhysicsRayQueryParameters3D.create(origin, origin + direction * range_meters)
	query.exclude = [get_parent().get_rid()]
	var result := world.direct_space_state.intersect_ray(query)
	if result.is_empty():
		return
	_perform_damage_result(result, damage)


func _perform_damage_result(result: Dictionary, damage: float) -> void:
	impact_registered.emit(result["position"], result["normal"])
	var collider: Object = result["collider"]
	if collider.has_method("receive_damage") and collider.call("receive_damage", damage):
		hit_confirmed.emit(damage)


func _apply_spread(direction: Vector3, spread_degrees: float) -> Vector3:
	var forward := direction.normalized()
	if spread_degrees <= 0.0:
		return forward
	var tangent := forward.cross(Vector3.UP)
	if tangent.length_squared() < 0.0001:
		tangent = forward.cross(Vector3.RIGHT)
	tangent = tangent.normalized()
	var bitangent := forward.cross(tangent).normalized()
	var spread := deg_to_rad(spread_degrees)
	return (
		forward
		+ tangent * randf_range(-spread, spread)
		+ bitangent * randf_range(-spread, spread)
	).normalized()
