extends Node

signal session_started(session_id: int)
signal session_paused(is_paused: bool)
signal session_ended(final_state: State)
signal session_reset
signal credits_changed(current_credits: int, delta: int)
signal purchase_succeeded(item_name: String, cost: int, remaining_credits: int)
signal purchase_failed(item_name: String, cost: int, available_credits: int)

const MAX_CREDITS := 2147483647

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


func get_credits() -> int:
	return int(_session.get("credits", 0))


func add_credits(amount: int) -> bool:
	if state != State.PLAYING or amount <= 0 or not has_active_session():
		return false
	var current_credits := get_credits()
	var next_credits := mini(MAX_CREDITS, current_credits + amount)
	if next_credits == current_credits:
		return false
	_session["credits"] = next_credits
	credits_changed.emit(next_credits, next_credits - current_credits)
	return true


func can_afford(cost: int) -> bool:
	return state == State.PLAYING and cost >= 0 and has_active_session() and get_credits() >= cost


func try_purchase(item_name: String, cost: int) -> bool:
	if cost < 0 or not has_active_session() or state != State.PLAYING:
		return false
	var current_credits := get_credits()
	if current_credits < cost:
		purchase_failed.emit(item_name, cost, current_credits)
		return false
	var remaining_credits := current_credits - cost
	_session["credits"] = remaining_credits
	credits_changed.emit(remaining_credits, -cost)
	purchase_succeeded.emit(item_name, cost, remaining_credits)
	return true


func get_session_snapshot() -> Dictionary:
	return _session.duplicate(true)
