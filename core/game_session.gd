extends Node

signal session_started(session_id: int)
signal session_paused(is_paused: bool)
signal session_ended(final_state: State)
signal session_reset

enum State {
	MENU,
	PLAYING,
	PAUSED,
	DEFEAT,
	VICTORY,
}

var state: State = State.MENU
var _next_session_id := 0
var _session: Dictionary = {}


func start_new_session() -> bool:
	if state != State.MENU and state != State.DEFEAT and state != State.VICTORY:
		return false

	reset_session()
	_next_session_id += 1
	_session = {
		"id": _next_session_id,
		"credits": 0,
		"wave": 0,
		"active_zombie_count": 0,
	}
	state = State.PLAYING
	session_started.emit(_next_session_id)
	return true


func toggle_pause() -> bool:
	if state == State.PLAYING:
		state = State.PAUSED
		session_paused.emit(true)
		return true
	if state == State.PAUSED:
		state = State.PLAYING
		session_paused.emit(false)
		return true
	return false


func finish_session(final_state: State) -> bool:
	if final_state != State.DEFEAT and final_state != State.VICTORY:
		return false
	if state != State.PLAYING and state != State.PAUSED:
		return false

	state = final_state
	session_ended.emit(final_state)
	return true


func return_to_menu() -> void:
	reset_session()


func reset_session() -> void:
	_session.clear()
	state = State.MENU
	session_reset.emit()


func has_active_session() -> bool:
	return not _session.is_empty()


func get_session_snapshot() -> Dictionary:
	return _session.duplicate(true)
