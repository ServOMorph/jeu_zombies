extends RefCounted

const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_countdown_pressure_and_unlock())
	failures.append_array(_test_death_during_finale_is_normal_defeat())
	return failures


func _advance_to_activer_extraction() -> void:
	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)
	QuestController.collect_component("composant_couloirs")
	QuestController.collect_component("composant_entrepot")
	QuestController.collect_component("composant_extraction")
	QuestController.try_advance(QuestController.State.DEPLOYER_ANTIDOTE)
	QuestController.try_advance(QuestController.State.ACTIVER_EXTRACTION)


func _test_countdown_pressure_and_unlock() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()
	if not GameSession.start_new_session():
		failures.append("la session de test doit démarrer")
		return failures

	var world := DEV_PLAYER_TEST.instantiate()
	tree.root.add_child(world)

	var controller: DefenseFinaleController = world.get_node("DefenseFinaleController")
	var defense_wave_manager: WaveManager = world.get_node("DefenseWaveManager")
	controller.duration_seconds = 1.0

	var reported: Array[float] = []
	controller.countdown_changed.connect(func(remaining: float) -> void:
		reported.append(remaining)
	)

	_advance_to_activer_extraction()
	QuestController.try_advance(QuestController.State.DEFENSE_FINALE)

	if not controller.is_active():
		failures.append("le contrôleur doit démarrer dès l'entrée en DEFENSE_FINALE")
	if reported.is_empty() or reported[0] != 1.0:
		failures.append("le compte à rebours initial doit être annoncé immédiatement")
	if defense_wave_manager.state == WaveManager.State.IDLE:
		failures.append("une vague de pression dédiée doit démarrer avec la finale")

	controller._process(0.6)
	if not controller.is_active():
		failures.append("le contrôleur reste actif tant que le chrono n'est pas écoulé")

	controller._process(0.6)
	if controller.is_active():
		failures.append("le contrôleur doit s'arrêter à la fin du chrono")
	if QuestController.state != QuestController.State.REJOINDRE_EXTRACTION:
		failures.append("la fin du chrono doit déverrouiller le point d'extraction (REJOINDRE_EXTRACTION)")
	if defense_wave_manager.state != WaveManager.State.IDLE:
		failures.append("les apparitions en cours doivent être annulées à la fin du chrono")

	var blockout: HelixBlockout = world.get_node("HelixBlockout")
	var terminal := blockout.get_extraction_terminal("terminal_extraction_salle")
	if terminal == null or not terminal.interact(world.player):
		failures.append("le terminal déverrouillé doit permettre de rejoindre l'extraction")
	if QuestController.state != QuestController.State.VICTOIRE:
		failures.append("rejoindre l'extraction après la finale doit déclencher la victoire")
	if GameSession.state != GameSession.State.VICTORY:
		failures.append("la victoire doit mettre fin à la session en VICTORY")

	world.free()
	GameSession.return_to_menu()
	return failures


func _test_death_during_finale_is_normal_defeat() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()
	if not GameSession.start_new_session():
		failures.append("la session de test doit démarrer")
		return failures

	var world := DEV_PLAYER_TEST.instantiate()
	tree.root.add_child(world)
	var controller: DefenseFinaleController = world.get_node("DefenseFinaleController")
	controller.duration_seconds = 120.0

	_advance_to_activer_extraction()
	QuestController.try_advance(QuestController.State.DEFENSE_FINALE)

	world.player.receive_damage(100000.0)

	if GameSession.state != GameSession.State.DEFEAT:
		failures.append("la mort pendant la défense finale doit déclencher une défaite normale")
	if controller.is_active():
		failures.append("le contrôleur doit s'arrêter après une défaite pendant la finale")

	world.free()
	GameSession.return_to_menu()
	return failures
