extends RefCounted

const STARTUP_SCENE := preload("res://ui/dev_startup/dev_startup.tscn")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var scene_tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()
	var startup := STARTUP_SCENE.instantiate()
	scene_tree.root.add_child(startup)
	var status_label := startup.get_node("Content/SessionStatus") as Label

	startup.call("_unhandled_key_input", _key_event(KEY_ENTER))
	if GameSession.state != GameSession.State.PLAYING:
		failures.append("Entrée doit démarrer la session depuis l'écran provisoire")
	if "PARTIE EN COURS" not in status_label.text:
		failures.append("l'écran provisoire doit afficher l'état PLAYING")

	startup.call("_unhandled_key_input", _key_event(KEY_P))
	if GameSession.state != GameSession.State.PAUSED:
		failures.append("P doit mettre la session en pause")
	if "PAUSE" not in status_label.text:
		failures.append("l'écran provisoire doit afficher l'état PAUSED")

	startup.call("_unhandled_key_input", _key_event(KEY_ESCAPE))
	if GameSession.state != GameSession.State.MENU or GameSession.has_active_session():
		failures.append("Échap doit détruire la session et revenir au menu")
	if "MENU" not in status_label.text:
		failures.append("l'écran provisoire doit afficher l'état MENU")

	scene_tree.root.remove_child(startup)
	startup.free()
	return failures


func _key_event(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.pressed = true
	return event
