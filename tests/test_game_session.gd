extends RefCounted

const GAME_SESSION_SCRIPT := preload("res://core/game_session.gd")


class SignalObserver:
	extends RefCounted

	var started := 0
	var paused := 0
	var ended := 0
	var reset := 0
	var last_pause_value := false
	var last_final_state := -1

	func _on_session_started(_session_id: int) -> void:
		started += 1

	func _on_session_paused(is_paused: bool) -> void:
		paused += 1
		last_pause_value = is_paused

	func _on_session_ended(final_state: int) -> void:
		ended += 1
		last_final_state = final_state

	func _on_session_reset() -> void:
		reset += 1


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var session := GAME_SESSION_SCRIPT.new()
	var observer := SignalObserver.new()
	session.session_started.connect(observer._on_session_started)
	session.session_paused.connect(observer._on_session_paused)
	session.session_ended.connect(observer._on_session_ended)
	session.session_reset.connect(observer._on_session_reset)

	if session.state != session.State.MENU:
		failures.append("l'état initial doit être MENU")
	if session.has_active_session():
		failures.append("aucune session ne doit exister à l'initialisation")
	if session.toggle_pause():
		failures.append("la pause doit être refusée depuis MENU")

	if not session.start_new_session():
		failures.append("le premier démarrage doit être accepté")
	if session.state != session.State.PLAYING:
		failures.append("le démarrage doit mener à PLAYING")
	var first_snapshot: Dictionary = session.get_session_snapshot()
	if first_snapshot.get("id") != 1 or first_snapshot.get("credits") != 0:
		failures.append("la première session doit être initialisée avec ses valeurs par défaut")
	if observer.started != 1 or observer.reset != 1:
		failures.append("les signaux de début et de remise à zéro doivent être émis")

	if not session.toggle_pause() or session.state != session.State.PAUSED:
		failures.append("PLAYING doit pouvoir passer à PAUSED")
	if not observer.last_pause_value:
		failures.append("le signal de pause doit indiquer true")
	if not session.toggle_pause() or session.state != session.State.PLAYING:
		failures.append("PAUSED doit pouvoir revenir à PLAYING")
	if observer.last_pause_value:
		failures.append("le signal de reprise doit indiquer false")

	session._session["credits"] = 999
	session.return_to_menu()
	if session.state != session.State.MENU or session.has_active_session():
		failures.append("le retour au menu doit détruire toute session active")
	if not session.start_new_session():
		failures.append("le deuxième démarrage doit être accepté")
	var second_snapshot: Dictionary = session.get_session_snapshot()
	if second_snapshot.get("id") != 2 or second_snapshot.get("credits") != 0:
		failures.append("le deuxième démarrage ne doit conserver aucun état de la première session")

	if not session.finish_session(session.State.DEFEAT):
		failures.append("PLAYING doit pouvoir passer à DEFEAT")
	if session.state != session.State.DEFEAT:
		failures.append("la fin par défaite doit mener à DEFEAT")
	if observer.ended != 1 or observer.last_final_state != session.State.DEFEAT:
		failures.append("le signal de fin doit indiquer DEFEAT")
	if not session.start_new_session() or session.state != session.State.PLAYING:
		failures.append("une session doit pouvoir recommencer après une défaite")
	if not session.finish_session(session.State.VICTORY):
		failures.append("PLAYING doit pouvoir passer à VICTORY")
	if session.state != session.State.VICTORY:
		failures.append("la fin par victoire doit mener à VICTORY")
	if session.finish_session(session.State.MENU):
		failures.append("une fin vers MENU doit être refusée")

	session.return_to_menu()
	if observer.started != 3 or observer.paused != 2 or observer.ended != 2:
		failures.append("les signaux de session doivent être émis exactement une fois par transition")
	if observer.reset != 5:
		failures.append("chaque création ou destruction doit remettre la session à zéro")
	session.free()
	return failures
