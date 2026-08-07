extends RefCounted

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const EXTRACTION_TERMINAL := preload("res://world/quest_extraction_terminal.gd")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const PLAYER := preload("res://player/player.tscn")
const EXTRACTION_TERMINAL_SALLE := preload("res://data/quest/extraction_terminal_salle.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_blockout_wiring())
	failures.append_array(_test_refuses_before_deployment())
	failures.append_array(_test_extraction_flow())
	return failures


func _test_blockout_wiring() -> Array[String]:
	var failures: Array[String] = []
	var expected_ids := PackedStringArray(["terminal_extraction_salle"])
	if HELIX_BLOCKOUT.get_extraction_terminal_ids() != expected_ids:
		failures.append("le blockout doit déclarer le terminal d'extraction de la Salle d'extraction")

	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout") as HelixBlockout
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	elif blockout.get_extraction_terminal("terminal_extraction_salle") == null:
		failures.append("le terminal d'extraction de la Salle d'extraction doit exister dans le blockout")
	world.free()
	return failures


func _test_refuses_before_deployment() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var terminal := EXTRACTION_TERMINAL.new()
	terminal.configure(EXTRACTION_TERMINAL_SALLE)
	tree.root.add_child(terminal)

	if terminal.interact(player):
		failures.append("l'extraction doit être refusée avant le déploiement de l'antidote")
	if QuestController.state == QuestController.State.DEFENSE_FINALE:
		failures.append("la quête ne doit pas progresser sans activation réelle")

	player.free()
	terminal.free()
	GameSession.return_to_menu()
	return failures


func _test_extraction_flow() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var terminal := EXTRACTION_TERMINAL.new()
	terminal.configure(EXTRACTION_TERMINAL_SALLE)
	tree.root.add_child(terminal)

	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)
	QuestController.collect_component("composant_couloirs")
	QuestController.collect_component("composant_entrepot")
	QuestController.collect_component("composant_extraction")
	QuestController.try_advance(QuestController.State.DEPLOYER_ANTIDOTE)
	QuestController.try_advance(QuestController.State.ACTIVER_EXTRACTION)

	if not terminal.interact(player):
		failures.append("l'activation doit réussir une fois l'antidote déployé")
	if QuestController.state != QuestController.State.DEFENSE_FINALE:
		failures.append("l'activation doit faire progresser la quête vers DEFENSE_FINALE")
	if terminal.interact(player):
		failures.append("une seconde interaction ne doit rien réactiver")

	player.free()
	terminal.free()
	GameSession.return_to_menu()
	return failures
