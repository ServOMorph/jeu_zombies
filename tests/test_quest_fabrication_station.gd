extends RefCounted

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const FABRICATION_STATION := preload("res://world/quest_fabrication_station.gd")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const PLAYER := preload("res://player/player.tscn")
const FABRICATION_STATION_LABORATOIRE := preload("res://data/quest/fabrication_station_laboratoire.tres")
const WAVE_MANAGER_SCRIPT := preload("res://systems/wave_manager.gd")
const WAVE_01 := preload("res://data/waves/wave_01.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_blockout_wiring())
	failures.append_array(_test_refuses_without_all_components())
	failures.append_array(_test_fabrication_flow())
	failures.append_array(_test_wave_start_does_not_interrupt_fabrication())
	failures.append_array(_test_session_reset_cancels_fabrication())
	GameSession.return_to_menu()
	return failures


func _test_blockout_wiring() -> Array[String]:
	var failures: Array[String] = []
	var expected_ids := PackedStringArray(["station_fabrication_laboratoire"])
	if HELIX_BLOCKOUT.get_fabrication_station_ids() != expected_ids:
		failures.append("le blockout doit déclarer la station de fabrication du Laboratoire")

	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout") as HelixBlockout
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	elif blockout.get_fabrication_station("station_fabrication_laboratoire") == null:
		failures.append("la station de fabrication du Laboratoire doit exister dans le blockout")
	world.free()
	return failures


func _test_refuses_without_all_components() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var station := FABRICATION_STATION.new()
	station.configure(FABRICATION_STATION_LABORATOIRE)
	tree.root.add_child(station)

	if station.interact(player):
		failures.append("la fabrication doit être refusée sans les trois composants")

	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)
	QuestController.collect_component("composant_couloirs")
	QuestController.collect_component("composant_entrepot")
	if station.interact(player):
		failures.append("la fabrication doit être refusée avec seulement deux composants sur trois")

	player.free()
	station.free()
	GameSession.return_to_menu()
	return failures


func _test_fabrication_flow() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var station := FABRICATION_STATION.new()
	station.configure(FABRICATION_STATION_LABORATOIRE)
	tree.root.add_child(station)
	station._fabrication_timer.wait_time = 100.0

	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)
	QuestController.collect_component("composant_couloirs")
	QuestController.collect_component("composant_entrepot")
	QuestController.collect_component("composant_extraction")

	if QuestController.state != QuestController.State.FABRIQUER_ANTIDOTE:
		failures.append("la collecte du troisième composant doit faire progresser la quête vers FABRIQUER_ANTIDOTE")

	if not station.interact(player):
		failures.append("la fabrication doit démarrer avec les trois composants réunis")
	if station.interact(player):
		failures.append("une seconde interaction pendant la fabrication ne doit rien redémarrer")
	if QuestController.state != QuestController.State.FABRIQUER_ANTIDOTE:
		failures.append("la quête ne doit pas progresser avant la fin de la fabrication")

	station._on_fabrication_finished()
	if QuestController.state != QuestController.State.DEPLOYER_ANTIDOTE:
		failures.append("la fin de la fabrication doit faire progresser la quête vers DEPLOYER_ANTIDOTE")

	player.free()
	station.free()
	GameSession.return_to_menu()
	return failures


func _test_wave_start_does_not_interrupt_fabrication() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var station := FABRICATION_STATION.new()
	station.configure(FABRICATION_STATION_LABORATOIRE)
	tree.root.add_child(station)
	station._fabrication_timer.wait_time = 100.0

	var wave_manager := WAVE_MANAGER_SCRIPT.new()
	tree.root.add_child(wave_manager)

	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)
	QuestController.collect_component("composant_couloirs")
	QuestController.collect_component("composant_entrepot")
	QuestController.collect_component("composant_extraction")
	station.interact(player)
	var time_left_before := station._fabrication_timer.time_left

	wave_manager.wave_started.emit(1, WAVE_01)

	if station._state != FABRICATION_STATION.State.FABRICATING:
		failures.append("le début d'une vague ne doit pas interrompre la fabrication en cours")
	if station._fabrication_timer.time_left != time_left_before:
		failures.append("le minuteur de fabrication ne doit pas être réinitialisé par le début d'une vague")

	player.free()
	station.free()
	wave_manager.free()
	GameSession.return_to_menu()
	return failures


func _test_session_reset_cancels_fabrication() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var station := FABRICATION_STATION.new()
	station.configure(FABRICATION_STATION_LABORATOIRE)
	tree.root.add_child(station)
	station._fabrication_timer.wait_time = 100.0

	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)
	QuestController.collect_component("composant_couloirs")
	QuestController.collect_component("composant_entrepot")
	QuestController.collect_component("composant_extraction")
	station.interact(player)

	GameSession.return_to_menu()
	if station._state != FABRICATION_STATION.State.IDLE:
		failures.append("la remise à zéro de session doit annuler une fabrication en cours")

	player.free()
	station.free()
	return failures
