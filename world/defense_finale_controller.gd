class_name DefenseFinaleController
extends Node

signal countdown_changed(remaining_seconds: float)
signal defense_finale_succeeded

const DEFAULT_DURATION_SECONDS := 120.0

@export var wave_manager: WaveManager
@export_range(1.0, 600.0, 1.0) var duration_seconds := DEFAULT_DURATION_SECONDS

var _target: Node3D
var _active := false
var _remaining_seconds := 0.0
var _last_reported_second := -1


func _ready() -> void:
	QuestController.state_changed.connect(_on_quest_state_changed)
	GameSession.session_reset.connect(_on_session_reset)
	GameSession.session_ended.connect(_on_session_ended)


func configure(target: Node3D) -> void:
	_target = target


func is_active() -> bool:
	return _active


func get_remaining_seconds() -> float:
	return _remaining_seconds


func stop() -> void:
	_active = false
	_remaining_seconds = 0.0
	_last_reported_second = -1
	if wave_manager != null:
		wave_manager.stop()


func _process(delta: float) -> void:
	if not _active:
		return
	_remaining_seconds = maxf(0.0, _remaining_seconds - delta)
	_report_remaining_if_changed()
	if _remaining_seconds <= 0.0:
		_finish_success()


func _on_quest_state_changed(_previous_state: int, new_state: int) -> void:
	if new_state == QuestController.State.DEFENSE_FINALE:
		_start()


func _on_session_reset() -> void:
	stop()


func _on_session_ended(final_state: int) -> void:
	if final_state == GameSession.State.DEFEAT or final_state == GameSession.State.VICTORY:
		stop()


func _start() -> void:
	_active = true
	_remaining_seconds = duration_seconds
	_last_reported_second = -1
	_report_remaining_if_changed()
	_start_defense_wave()


func _start_defense_wave() -> void:
	if wave_manager == null or _target == null:
		return
	wave_manager.stop()
	wave_manager.current_wave_number = 0
	wave_manager.start_next_wave(_target)


func _finish_success() -> void:
	_active = false
	if wave_manager != null:
		wave_manager.stop()
	QuestController.try_advance(QuestController.State.REJOINDRE_EXTRACTION)
	defense_finale_succeeded.emit()


func _report_remaining_if_changed() -> void:
	var whole_seconds := int(ceil(_remaining_seconds))
	if whole_seconds == _last_reported_second:
		return
	_last_reported_second = whole_seconds
	countdown_changed.emit(float(whole_seconds))
