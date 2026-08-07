extends RefCounted

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const DEPLOYMENT_POINT := preload("res://world/quest_deployment_point.gd")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const PLAYER := preload("res://player/player.tscn")
const DEPLOYMENT_POINT_LABORATOIRE := preload("res://data/quest/deployment_point_laboratoire.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_blockout_wiring())
	failures.append_array(_test_refuses_before_fabrication())
	failures.append_array(_test_deployment_flow())
	return failures


func _test_blockout_wiring() -> Array[String]:
	var failures: Array[String] = []
	var expected_ids := PackedStringArray(["point_deploiement_laboratoire"])
	if HELIX_BLOCKOUT.get_deployment_point_ids() != expected_ids:
		failures.append("le blockout doit déclarer le point de déploiement du Laboratoire")

	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout") as HelixBlockout
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	elif blockout.get_deployment_point("point_deploiement_laboratoire") == null:
		failures.append("le point de déploiement du Laboratoire doit exister dans le blockout")
	world.free()
	return failures


func _test_refuses_before_fabrication() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var point := DEPLOYMENT_POINT.new()
	point.configure(DEPLOYMENT_POINT_LABORATOIRE)
	tree.root.add_child(point)

	if point.interact(player):
		failures.append("le déploiement doit être refusé avant la fabrication de l'antidote")
	if QuestController.state == QuestController.State.ACTIVER_EXTRACTION:
		failures.append("la quête ne doit pas progresser sans déploiement réel")

	player.free()
	point.free()
	GameSession.return_to_menu()
	return failures


func _test_deployment_flow() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var point := DEPLOYMENT_POINT.new()
	point.configure(DEPLOYMENT_POINT_LABORATOIRE)
	tree.root.add_child(point)

	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)
	QuestController.collect_component("composant_couloirs")
	QuestController.collect_component("composant_entrepot")
	QuestController.collect_component("composant_extraction")
	QuestController.try_advance(QuestController.State.DEPLOYER_ANTIDOTE)

	if not point.interact(player):
		failures.append("le déploiement doit réussir une fois l'antidote fabriqué")
	if QuestController.state != QuestController.State.ACTIVER_EXTRACTION:
		failures.append("le déploiement doit faire progresser la quête vers ACTIVER_EXTRACTION")
	if point.interact(player):
		failures.append("une seconde interaction ne doit rien redéployer")

	player.free()
	point.free()
	GameSession.return_to_menu()
	return failures
