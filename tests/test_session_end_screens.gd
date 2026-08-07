extends RefCounted

const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_defeat_blocks_and_restarts())
	failures.append_array(_test_victory_blocks_and_restarts())
	failures.append_array(_test_victory_then_menu_then_restart())
	return failures


func _setup_world() -> Dictionary:
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()
	if not GameSession.start_new_session():
		return {}
	var world := DEV_PLAYER_TEST.instantiate()
	tree.root.add_child(world)
	return {"world": world}


func _advance_to_victory(world) -> bool:
	var blockout: HelixBlockout = world.get_node("HelixBlockout")
	var terminal := blockout.get_extraction_terminal("terminal_extraction_salle")
	var controller: DefenseFinaleController = world.get_node("DefenseFinaleController")
	controller.duration_seconds = 0.1
	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)
	QuestController.collect_component("composant_couloirs")
	QuestController.collect_component("composant_entrepot")
	QuestController.collect_component("composant_extraction")
	QuestController.try_advance(QuestController.State.DEPLOYER_ANTIDOTE)
	QuestController.try_advance(QuestController.State.ACTIVER_EXTRACTION)
	if not terminal.interact(world.player):
		return false
	controller._process(1.0)
	return terminal.interact(world.player)


func _test_defeat_blocks_and_restarts() -> Array[String]:
	var failures: Array[String] = []
	var setup := _setup_world()
	if setup.is_empty():
		failures.append("la session de test doit démarrer")
		return failures
	var world = setup["world"]

	GameSession.add_credits(500)
	world.player.receive_damage(1000000.0)

	if GameSession.state != GameSession.State.DEFEAT:
		failures.append("la mort du joueur doit déclencher DEFEAT")
	if world.player.is_physics_processing():
		failures.append("le déplacement et le combat doivent être bloqués sous l'écran de défaite")
	if world.player.weapon_controller.try_fire(Vector3.ZERO, Vector3.FORWARD):
		failures.append("le tir doit être bloqué sous l'écran de défaite")
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		failures.append("la souris doit redevenir visible sous l'écran de défaite")
	if not world.defeat_label.visible:
		failures.append("l'écran de défaite doit s'afficher")

	if not GameSession.start_new_session():
		failures.append("une nouvelle partie doit pouvoir démarrer après une défaite")
	if GameSession.state != GameSession.State.PLAYING:
		failures.append("l'état doit repasser à PLAYING après une nouvelle partie")
	if GameSession.get_credits() != 0:
		failures.append("les crédits doivent être remis à zéro pour la nouvelle partie")
	if QuestController.state != QuestController.State.SURVIVRE:
		failures.append("la quête doit repartir de SURVIVRE pour la nouvelle partie")

	world.free()
	GameSession.return_to_menu()
	return failures


func _test_victory_blocks_and_restarts() -> Array[String]:
	var failures: Array[String] = []
	var setup := _setup_world()
	if setup.is_empty():
		failures.append("la session de test doit démarrer")
		return failures
	var world = setup["world"]

	GameSession.add_credits(500)
	if not _advance_to_victory(world):
		failures.append("le scénario doit pouvoir atteindre la victoire")
		world.free()
		GameSession.return_to_menu()
		return failures

	if GameSession.state != GameSession.State.VICTORY:
		failures.append("rejoindre l'extraction après la finale doit déclencher VICTORY")
	if world.player.is_physics_processing():
		failures.append("le déplacement et le combat doivent être bloqués sous l'écran de victoire")
	if world.player.weapon_controller.try_fire(Vector3.ZERO, Vector3.FORWARD):
		failures.append("le tir doit être bloqué sous l'écran de victoire")
	if not world.victory_label.visible:
		failures.append("l'écran de victoire doit s'afficher")

	if not GameSession.start_new_session():
		failures.append("une nouvelle partie doit pouvoir démarrer après une victoire")
	if GameSession.state != GameSession.State.PLAYING:
		failures.append("l'état doit repasser à PLAYING après une nouvelle partie")
	if GameSession.get_credits() != 0:
		failures.append("les crédits doivent être remis à zéro pour la nouvelle partie")

	world.free()
	GameSession.return_to_menu()
	return failures


func _test_victory_then_menu_then_restart() -> Array[String]:
	var failures: Array[String] = []
	var setup := _setup_world()
	if setup.is_empty():
		failures.append("la session de test doit démarrer")
		return failures
	var world = setup["world"]

	if not _advance_to_victory(world):
		failures.append("le scénario doit pouvoir atteindre la victoire")
		world.free()
		GameSession.return_to_menu()
		return failures

	GameSession.return_to_menu()
	if GameSession.state != GameSession.State.MENU or GameSession.has_active_session():
		failures.append("le retour au menu après une victoire doit détruire la session")
	if QuestController.state != QuestController.State.SURVIVRE:
		failures.append("le retour au menu doit remettre la quête à SURVIVRE")

	if not GameSession.start_new_session():
		failures.append("une nouvelle partie doit pouvoir démarrer depuis le menu après une victoire")
	if GameSession.state != GameSession.State.PLAYING:
		failures.append("l'état doit repasser à PLAYING")

	world.free()
	GameSession.return_to_menu()
	return failures
