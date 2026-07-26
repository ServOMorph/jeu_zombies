extends RefCounted

const GAME_SESSION_SCRIPT := preload("res://core/game_session.gd")


class SignalObserver:
	extends RefCounted

	var started := 0
	var paused := 0
	var ended := 0
	var reset := 0
	var credits_events := 0
	var purchase_successes := 0
	var purchase_failures := 0
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

	func _on_credits_changed(_current_credits: int, _delta: int) -> void:
		credits_events += 1

	func _on_purchase_succeeded(_item_name: String, _cost: int, _remaining: int) -> void:
		purchase_successes += 1

	func _on_purchase_failed(_item_name: String, _cost: int, _available: int) -> void:
		purchase_failures += 1


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var session := GAME_SESSION_SCRIPT.new()
	var observer := SignalObserver.new()
	session.session_started.connect(observer._on_session_started)
	session.session_paused.connect(observer._on_session_paused)
	session.session_ended.connect(observer._on_session_ended)
	session.session_reset.connect(observer._on_session_reset)
	session.credits_changed.connect(observer._on_credits_changed)
	session.purchase_succeeded.connect(observer._on_purchase_succeeded)
	session.purchase_failed.connect(observer._on_purchase_failed)

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
	if not session.add_credits(100) or session.get_credits() != 100:
		failures.append("une récompense positive doit créditer la session")
	if session.add_credits(0) or session.add_credits(-1):
		failures.append("une récompense nulle ou négative doit être refusée")
	if not session.can_afford(100) or session.can_afford(101):
		failures.append("le contrôle de solvabilité doit utiliser le solde réel")
	if not session.try_purchase("Test", 40) or session.get_credits() != 60:
		failures.append("un achat solvable doit être débité atomiquement")
	if session.try_purchase("Test", 61) or session.get_credits() != 60:
		failures.append("un achat non solvable doit être refusé sans débit")
	if observer.purchase_successes != 1 or observer.purchase_failures != 1:
		failures.append("les achats réussis et refusés doivent produire des feedbacks distincts")
	if not session.add_credits(session.MAX_CREDITS) or session.get_credits() != session.MAX_CREDITS:
		failures.append("le solde doit être borné sans dépassement")
	if session.add_credits(1):
		failures.append("un solde au maximum ne doit pas déborder")

	if not session.toggle_pause() or session.state != session.State.PAUSED:
		failures.append("PLAYING doit pouvoir passer à PAUSED")
	if not observer.last_pause_value:
		failures.append("le signal de pause doit indiquer true")
	if not session.toggle_pause() or session.state != session.State.PLAYING:
		failures.append("PAUSED doit pouvoir revenir à PLAYING")
	if observer.last_pause_value:
		failures.append("le signal de reprise doit indiquer false")

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
