class_name ZombieSpawner
extends Node3D

const ZOMBIE_SPAWN_POINT_SCRIPT := preload("res://enemies/zombie_spawn_point.gd")

signal zombie_spawned(zombie: ZombieStandard, spawn_point: Node3D, used_fallback: bool)
signal spawn_deferred(zone_id: String)

@export var zombie_scene: PackedScene
@export_range(1, 128, 1) var max_active_zombies := 12
@export_range(0.0, 30.0, 0.5) var player_exclusion_radius_meters := 6.0
@export_range(0.1, 10.0, 0.1) var navigation_projection_max_distance := 2.0
@export_range(0, 128, 1) var prewarm_pool_size := 8

var _active_zombies: Array[ZombieStandard] = []
var _pooled_zombies: Array[ZombieStandard] = []
var _last_spawn_used_fallback := false


func _ready() -> void:
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
		spawn_deferred.emit(zone_id)
		return null
	var resolved_target := target if is_instance_valid(target) else _resolve_player()
	if resolved_target == null:
		spawn_deferred.emit(zone_id)
		return null
	var spawn_point := _find_spawn_point(zone_id, resolved_target)
	if spawn_point == null:
		spawn_deferred.emit(zone_id)
		return null
	var zombie := _take_pooled_zombie()
	if zombie == null:
		spawn_deferred.emit(zone_id)
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
	var index := select_candidate_index(distances, paths_valid, player_exclusion_radius_meters)
	return points[index] if index >= 0 else null


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
