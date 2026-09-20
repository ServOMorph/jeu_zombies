class_name ZombieSpawner
extends Node3D

const ZOMBIE_SPAWN_POINT_SCRIPT := preload("res://enemies/zombie_spawn_point.gd")

signal zombie_spawned(zombie: ZombieStandard, spawn_point: Node3D, used_fallback: bool)
signal spawn_deferred(zone_id: String, reason: DeferReason)

enum DeferReason {
	CAPPED,
	NO_TARGET,
	NO_VALID_POINT,
	POOL_EXHAUSTED,
}

@export var zombie_scene: PackedScene
@export_range(1, 128, 1) var max_active_zombies := 12
@export_range(0.0, 30.0, 0.5) var player_exclusion_radius_meters := 6.0
@export_range(0.1, 10.0, 0.1) var navigation_projection_max_distance := 2.0
@export_range(0, 128, 1) var prewarm_pool_size := 8
@export var randomize_valid_spawn_points := false
@export var prefer_nearest_valid_spawn_point := false
@export_range(1, 16, 1) var nearest_candidate_pool_size := 5

var _active_zombies: Array[ZombieStandard] = []
var _pooled_zombies: Array[ZombieStandard] = []
var _last_spawn_used_fallback := false
var _rng := RandomNumberGenerator.new()
var _random_spawn_bag: Array[Node3D] = []


func _ready() -> void:
	_rng.randomize()
	for _index in prewarm_pool_size:
		var zombie := _create_pooled_zombie()
		if zombie == null:
			return


func request_spawn(
	zone_id: String,
	target: Node3D = null,
	health_multiplier: float = 1.0,
) -> ZombieStandard:
	_prune_active_zombies()
	if not can_spawn(get_active_zombie_count(), max_active_zombies):
		spawn_deferred.emit(zone_id, DeferReason.CAPPED)
		return null
	var resolved_target := target if is_instance_valid(target) else _resolve_player()
	if resolved_target == null:
		spawn_deferred.emit(zone_id, DeferReason.NO_TARGET)
		return null
	var spawn_point := _find_spawn_point(zone_id, resolved_target)
	if spawn_point == null:
		spawn_deferred.emit(zone_id, DeferReason.NO_VALID_POINT)
		return null
	var zombie := _take_pooled_zombie()
	if zombie == null:
		spawn_deferred.emit(zone_id, DeferReason.POOL_EXHAUSTED)
		return null
	zombie.global_position = _get_navigation_position(spawn_point.global_position)
	zombie.activate(resolved_target, zombie.create_wave_definition(health_multiplier))
	_active_zombies.append(zombie)
	zombie_spawned.emit(zombie, spawn_point, _last_spawn_used_fallback)
	return zombie


func get_active_zombie_count() -> int:
	_prune_active_zombies()
	var active_count := 0
	for node: Node in get_tree().get_nodes_in_group("zombies"):
		if not node is ZombieStandard:
			continue
		var zombie := node as ZombieStandard
		if zombie.state != ZombieStandard.State.INACTIVE and zombie.state != ZombieStandard.State.DYING:
			active_count += 1
	return active_count


func last_spawn_used_fallback() -> bool:
	return _last_spawn_used_fallback


func deactivate_all() -> void:
	for zombie: ZombieStandard in _pooled_zombies:
		if is_instance_valid(zombie):
			zombie.deactivate()
	_active_zombies.clear()


func _find_spawn_point(zone_id: String, target: Node3D) -> Node3D:
	_last_spawn_used_fallback = false
	var primary_points: Array[Node3D] = []
	var fallback_points: Array[Node3D] = []
	for node: Node in get_tree().get_nodes_in_group("zombie_spawn_points"):
		if not node is Node3D or node.get_script() != ZOMBIE_SPAWN_POINT_SCRIPT:
			continue
		var point := node as Node3D
		if str(point.get("zone_id")) == zone_id:
			primary_points.append(point)
		else:
			fallback_points.append(point)
	var primary := _find_first_valid_point(primary_points, target)
	if primary != null:
		return primary
	var fallback := _find_first_valid_point(fallback_points, target)
	if fallback != null:
		_last_spawn_used_fallback = true
	return fallback


func _find_first_valid_point(points: Array[Node3D], target: Node3D) -> Node3D:
	var distances: Array[float] = []
	var paths_valid: Array[bool] = []
	for point: Node3D in points:
		distances.append(point.global_position.distance_to(target.global_position))
		paths_valid.append(_has_navigation_path(point, target))
	if prefer_nearest_valid_spawn_point:
		var nearest_indices := select_nearest_candidate_indices(
			distances,
			paths_valid,
			player_exclusion_radius_meters,
			nearest_candidate_pool_size,
		)
		var nearest_points: Array[Node3D] = []
		for index in nearest_indices:
			nearest_points.append(points[index])
		return _take_cycled_candidates(nearest_points)
	if randomize_valid_spawn_points:
		return _take_cycled_random_point(points, distances, paths_valid)
	var index := _select_candidate_index(distances, paths_valid)
	return points[index] if index >= 0 else null


func _take_cycled_random_point(
	points: Array[Node3D],
	distances: Array[float],
	paths_valid: Array[bool]
) -> Node3D:
	var valid_points: Array[Node3D] = []
	for index in mini(points.size(), mini(distances.size(), paths_valid.size())):
		if paths_valid[index] and is_outside_player_exclusion(distances[index], player_exclusion_radius_meters):
			valid_points.append(points[index])
	if valid_points.is_empty():
		return null
	return _take_cycled_candidates(valid_points)


func _take_cycled_candidates(valid_points: Array[Node3D]) -> Node3D:
	if valid_points.is_empty():
		return null
	for index in range(_random_spawn_bag.size() - 1, -1, -1):
		if not valid_points.has(_random_spawn_bag[index]):
			_random_spawn_bag.remove_at(index)
	if _random_spawn_bag.is_empty():
		_random_spawn_bag = valid_points.duplicate()
		for index in range(_random_spawn_bag.size() - 1, 0, -1):
			var swap_index := _rng.randi_range(0, index)
			var point := _random_spawn_bag[index]
			_random_spawn_bag[index] = _random_spawn_bag[swap_index]
			_random_spawn_bag[swap_index] = point
	return _random_spawn_bag.pop_back()


func _select_candidate_index(distances: Array[float], paths_valid: Array[bool]) -> int:
	if not randomize_valid_spawn_points:
		return select_candidate_index(distances, paths_valid, player_exclusion_radius_meters)
	var candidates: Array[int] = []
	for index in mini(distances.size(), paths_valid.size()):
		if paths_valid[index] and is_outside_player_exclusion(distances[index], player_exclusion_radius_meters):
			candidates.append(index)
	return -1 if candidates.is_empty() else candidates[_rng.randi_range(0, candidates.size() - 1)]


func _has_navigation_path(point: Node3D, target: Node3D) -> bool:
	if not bool(point.get("is_enabled")):
		return false
	var navigation_map := get_world_3d().navigation_map
	if NavigationServer3D.map_get_iteration_id(navigation_map) == 0:
		return false
	var source := _get_navigation_position(point.global_position)
	var destination := _get_navigation_position(target.global_position)
	if source.distance_to(point.global_position) > navigation_projection_max_distance:
		return false
	if destination.distance_to(target.global_position) > navigation_projection_max_distance:
		return false
	var path := NavigationServer3D.map_get_path(navigation_map, source, destination, true)
	return path.size() > 1


func _get_navigation_position(position: Vector3) -> Vector3:
	return NavigationServer3D.map_get_closest_point(get_world_3d().navigation_map, position)


func _take_pooled_zombie() -> ZombieStandard:
	for zombie: ZombieStandard in _pooled_zombies:
		if zombie.state == ZombieStandard.State.INACTIVE:
			return zombie
	return null


func _create_pooled_zombie() -> ZombieStandard:
	if zombie_scene == null:
		return null
	var instance := zombie_scene.instantiate()
	if not instance is ZombieStandard:
		push_error("La scène d'apparition doit instancier ZombieStandard.")
		instance.queue_free()
		return null
	var zombie := instance as ZombieStandard
	zombie.start_active = false
	add_child(zombie)
	zombie.died.connect(_on_zombie_died.bind(zombie))
	_pooled_zombies.append(zombie)
	return zombie


func _on_zombie_died(zombie: ZombieStandard) -> void:
	_active_zombies.erase(zombie)


func _prune_active_zombies() -> void:
	for index in range(_active_zombies.size() - 1, -1, -1):
		var zombie := _active_zombies[index]
		if not is_instance_valid(zombie) or zombie.state == ZombieStandard.State.INACTIVE:
			_active_zombies.remove_at(index)


func _resolve_player() -> Node3D:
	var players := get_tree().get_nodes_in_group("player")
	return players.front() as Node3D if not players.is_empty() else null


static func can_spawn(active_count: int, maximum_active: int) -> bool:
	return maximum_active > 0 and active_count < maximum_active


static func is_outside_player_exclusion(distance_to_player: float, exclusion_radius: float) -> bool:
	return distance_to_player >= exclusion_radius


static func select_candidate_index(
	distances_to_player: Array[float],
	paths_valid: Array[bool],
	exclusion_radius: float,
) -> int:
	var candidate_count := mini(distances_to_player.size(), paths_valid.size())
	for index in candidate_count:
		if paths_valid[index] and is_outside_player_exclusion(distances_to_player[index], exclusion_radius):
			return index
	return -1


static func select_nearest_candidate_index(
	distances_to_player: Array[float],
	paths_valid: Array[bool],
	exclusion_radius: float,
) -> int:
	var candidate_index := -1
	var nearest_distance := INF
	var candidate_count := mini(distances_to_player.size(), paths_valid.size())
	for index in candidate_count:
		var distance := distances_to_player[index]
		if paths_valid[index] and is_outside_player_exclusion(distance, exclusion_radius) and distance < nearest_distance:
			candidate_index = index
			nearest_distance = distance
	return candidate_index


static func select_nearest_candidate_indices(
	distances_to_player: Array[float],
	paths_valid: Array[bool],
	exclusion_radius: float,
	maximum_candidates: int,
) -> Array[int]:
	var candidate_indices: Array[int] = []
	var candidate_count := mini(distances_to_player.size(), paths_valid.size())
	for index in candidate_count:
		if paths_valid[index] and is_outside_player_exclusion(distances_to_player[index], exclusion_radius):
			candidate_indices.append(index)
	candidate_indices.sort_custom(func(left: int, right: int): return distances_to_player[left] < distances_to_player[right])
	if candidate_indices.size() > maximum_candidates:
		candidate_indices.resize(maximum_candidates)
	return candidate_indices
