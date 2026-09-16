class_name PortExtractionController
extends Node

signal countdown_changed(remaining_seconds: float, is_paused: bool)
signal extraction_succeeded

@export var defense_wave_manager: WaveManager

var _player: Node3D
var _zone_center := Vector3.ZERO
var _zone_radius := 8.0
var _active := false
var _remaining_seconds := 0.0
var _last_whole_second := -1


func configure(player: Node3D, zone_center: Vector3, zone_radius: float) -> void:
	_player = player
	_zone_center = zone_center
	_zone_radius = zone_radius


func start(definition: WaveDefinition) -> bool:
	if _active or _player == null or defense_wave_manager == null:
		return false
	_active = true
	_remaining_seconds = PortBalance.get_value("extraction_duration")
	_last_whole_second = -1
	defense_wave_manager.stop()
	defense_wave_manager.wave_definitions = [definition]
	defense_wave_manager.start_next_wave(_player)
	_report()
	return true


func is_active() -> bool:
	return _active


func get_remaining_seconds() -> float:
	return _remaining_seconds


func _process(delta: float) -> void:
	if not _active or GameSession.state != GameSession.State.PLAYING:
		return
	var is_inside := _player.global_position.distance_to(_zone_center) <= _zone_radius
	if is_inside:
		_remaining_seconds = maxf(0.0, _remaining_seconds - delta)
	_report()
	if _remaining_seconds <= 0.0 and is_inside:
		_active = false
		defense_wave_manager.stop()
		extraction_succeeded.emit()


func _report() -> void:
	var whole_seconds := int(ceil(_remaining_seconds))
	if whole_seconds == _last_whole_second:
		return
	_last_whole_second = whole_seconds
	var is_inside := _player != null and _player.global_position.distance_to(_zone_center) <= _zone_radius
	countdown_changed.emit(float(whole_seconds), not is_inside)
