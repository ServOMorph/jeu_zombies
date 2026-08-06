extends RefCounted

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const QUEST_COMPONENT := preload("res://world/quest_component.gd")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const PLAYER := preload("res://player/player.tscn")
const COMPONENT_COULOIRS := preload("res://data/quest/component_couloirs.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_blockout_wiring())
	failures.append_array(_test_collect_requires_quest_state())
	failures.append_array(_test_collect_flow_and_double_collection())
	failures.append_array(_test_session_reset_restores_component())
	GameSession.return_to_menu()
	return failures


func _test_blockout_wiring() -> Array[String]:
	var failures: Array[String] = []
	var expected_ids := PackedStringArray(["composant_couloirs", "composant_entrepot", "composant_extraction"])
	if HELIX_BLOCKOUT.get_quest_component_ids() != expected_ids:
		failures.append("le blockout doit déclarer les trois composants d'antidote")

	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout") as HelixBlockout
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	else:
		for component_id: String in expected_ids:
			if blockout.get_quest_component(component_id) == null:
				failures.append("le composant %s doit exister dans le blockout" % component_id)
	world.free()
	return failures


func _test_collect_requires_quest_state() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var component := QUEST_COMPONENT.new()
	component.configure(COMPONENT_COULOIRS)
	tree.root.add_child(component)

	if component.interact(player):
		failures.append("la collecte doit être refusée avant l'état RECUPERER_LES_COMPOSANTS")

	player.free()
	component.free()
	return failures


func _test_collect_flow_and_double_collection() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var component := QUEST_COMPONENT.new()
	component.configure(COMPONENT_COULOIRS)
	tree.root.add_child(component)

	if not component.interact(player):
		failures.append("la collecte doit réussir une fois les zones accessibles")
	if not QuestController.has_component("composant_couloirs"):
		failures.append("le contrôleur de quête doit mémoriser le composant récupéré")
	if component.interact(player):
		failures.append("une double collecte du même composant doit être refusée")

	player.free()
	component.free()
	GameSession.return_to_menu()
	return failures


func _test_session_reset_restores_component() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	QuestController.try_advance(QuestController.State.OUVRIR_LES_ZONES)
	QuestController.try_advance(QuestController.State.RECUPERER_LES_COMPOSANTS)

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var component := QUEST_COMPONENT.new()
	component.configure(COMPONENT_COULOIRS)
	tree.root.add_child(component)
	component.interact(player)

	GameSession.return_to_menu()
	if QuestController.has_component("composant_couloirs"):
		failures.append("la remise à zéro de session doit effacer les composants récupérés")
	if not component.can_interact(player):
		failures.append("un composant doit redevenir collectable après remise à zéro")

	player.free()
	component.free()
	return failures
