class_name WaveManager
extends Node

signal state_changed(new_state: State)
signal wave_started(wave_number: int, definition: WaveDefinition)
signal remaining_zombies_changed(remaining_count: int)
signal wave_finished(wave_number: int)
signal waves_completed

enum State {
	IDLE,
	SPAWNING,
	WAITING_FOR_CLEAR,
	INTERMISSION,
	COMPLETED,
}

@export var zombie_spawner: ZombieSpawner
@export var wave_definitions: Array[WaveDefinition] = []
@export_range(0.0, 60.0, 0.1) var intermission_seconds := 6.0
@export var auto_advance_waves := true

var state: State = State.IDLE
var current_wave_number := 0
var _remaining_to_spawn := 0
var _spawn_remaining_seconds := 0.0
var _intermission_remaining_seconds := 0.0
var _target: Node3D
var _wave_zombies: Array[ZombieStandard] = []
var _last_reported_remaining := -1


func _process(delta: float) -> void:
	match state:
		State.SPAWNING:
			_process_spawning(delta)
		State.WAITING_FOR_CLEAR:
			_process_waiting_for_clear()
		State.INTERMISSION:
			_process_intermission(delta)
	_report_remaining_if_changed()


func start_next_wave(target: Node3D) -> bool:
	if not can_start_next_wave(state, current_wave_number, wave_definitions.size()) or target == null:
		return false
	return _start_wave_at_index(current_wave_number, target)


func start_wave_for_test(wave_number: int, target: Node3D) -> bool:
	if not OS.is_debug_build() or state != State.IDLE or target == null:
		return false
	return _start_wave_at_index(wave_number - 1, target)


func get_remaining_zombie_count() -> int:
	_prune_wave_zombies()
	return remaining_zombie_count(_remaining_to_spawn, _wave_zombies.size())


func get_intermission_remaining_seconds() -> float:
	return _intermission_remaining_seconds


func _start_wave_at_index(wave_index: int, target: Node3D) -> bool:
	if zombie_spawner == null or not is_valid_wave_index(wave_index, wave_definitions.size()):
		return false
	var definition := wave_definitions[wave_index]
	if not is_valid_wave_definition(definition):
		push_error("Configuration de vague invalide.")
		return false
	current_wave_number = wave_index + 1
	_target = target
	_remaining_to_spawn = definition.zombie_count
	_spawn_remaining_seconds = 0.0
	_intermission_remaining_seconds = 0.0
	_wave_zombies.clear()
	_set_state(State.SPAWNING)
	wave_started.emit(current_wave_number, definition)
	_report_remaining_if_changed()
	return true


func _process_spawning(delta: float) -> void:
	_spawn_remaining_seconds = maxf(0.0, _spawn_remaining_seconds - delta)
	if _remaining_to_spawn == 0:
		_set_state(State.WAITING_FOR_CLEAR)
		return
	if _spawn_remaining_seconds > 0.0:
		return
	var definition := wave_definitions[current_wave_number - 1]
	var zombie := zombie_spawner.request_spawn(
		definition.spawn_zone_id,
		_target,
		definition.health_multiplier,
	)
	_spawn_remaining_seconds = definition.spawn_interval_seconds
	if zombie == null:
		return
	_wave_zombies.append(zombie)
	_remaining_to_spawn -= 1
	if _remaining_to_spawn == 0:
		_set_state(State.WAITING_FOR_CLEAR)


func _process_waiting_for_clear() -> void:
	if get_remaining_zombie_count() > 0:
		return
	if current_wave_number >= wave_definitions.size():
		wave_finished.emit(current_wave_number)
		_set_state(State.COMPLETED)
		waves_completed.emit()
		return
	_intermission_remaining_seconds = intermission_seconds
	wave_finished.emit(current_wave_number)
	_set_state(State.INTERMISSION)


func _process_intermission(delta: float) -> void:
	_intermission_remaining_seconds = maxf(0.0, _intermission_remaining_seconds - delta)
	if _intermission_remaining_seconds > 0.0:
		return
	if auto_advance_waves:
		_start_wave_at_index(current_wave_number, _target)
	else:
		_set_state(State.IDLE)


func _prune_wave_zombies() -> void:
	for index in range(_wave_zombies.size() - 1, -1, -1):
		var zombie := _wave_zombies[index]
		if not is_instance_valid(zombie) or zombie.state == ZombieStandard.State.INACTIVE or zombie.state == ZombieStandard.State.DYING:
			_wave_zombies.remove_at(index)


func _report_remaining_if_changed() -> void:
	var remaining := get_remaining_zombie_count()
	if remaining == _last_reported_remaining:
		return
	_last_reported_remaining = remaining
	remaining_zombies_changed.emit(remaining)


func _set_state(new_state: State) -> void:
	if state == new_state:
		return
	state = new_state
	state_changed.emit(state)


static func is_valid_wave_definition(definition: WaveDefinition) -> bool:
	return (
		definition != null
		and not definition.spawn_zone_id.is_empty()
		and definition.zombie_count > 0
		and definition.health_multiplier > 0.0
		and definition.spawn_interval_seconds > 0.0
	)


static func is_valid_wave_index(wave_index: int, wave_count: int) -> bool:
	return wave_index >= 0 and wave_index < wave_count


static func remaining_zombie_count(remaining_to_spawn: int, living_count: int) -> int:
	return maxi(0, remaining_to_spawn) + maxi(0, living_count)


static func can_start_next_wave(current_state: State, current_wave: int, wave_count: int) -> bool:
	return current_state == State.IDLE and current_wave >= 0 and current_wave < wave_count
