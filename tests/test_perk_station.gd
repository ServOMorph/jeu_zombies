extends RefCounted

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const PERK_STATION := preload("res://world/perk_station.gd")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const PLAYER := preload("res://player/player.tscn")
const PERK_CONSTITUTION := preload("res://data/perks/perk_constitution_renforcee.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_blockout_wiring())
	failures.append_array(_test_purchase_flow())
	failures.append_array(_test_refuses_second_purchase_without_charge())
	GameSession.return_to_menu()
	return failures


func _test_blockout_wiring() -> Array[String]:
	var failures: Array[String] = []
	var expected_ids := PackedStringArray([
		"constitution_renforcee",
		"gestes_precis",
		"reflexes_stimules",
		"reparation_cellulaire",
	])
	if HELIX_BLOCKOUT.get_perk_station_ids() != expected_ids:
		failures.append("le blockout doit déclarer les quatre stations d'avantages")

	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout") as HelixBlockout
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	else:
		for perk_id: String in expected_ids:
			if blockout.get_perk_station(perk_id) == null:
				failures.append("la station d'avantage %s doit exister dans le blockout" % perk_id)
	world.free()
	return failures


func _test_purchase_flow() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var station := PERK_STATION.new()
	station.configure(PERK_CONSTITUTION)
	tree.root.add_child(station)

	GameSession.start_new_session()

	if station.interact(player):
		failures.append("l'achat sans crédits suffisants doit être refusé")
	if GameSession.get_credits() != 0:
		failures.append("un achat refusé ne doit pas modifier les crédits")

	GameSession.add_credits(station.price_credits)
	if not station.interact(player):
		failures.append("l'achat avec assez de crédits doit réussir")
	if GameSession.get_credits() != 0:
		failures.append("l'achat doit débiter exactement son prix une seule fois")
	if not player.perks.is_owned(PERK_CONSTITUTION.perk_id):
		failures.append("l'avantage doit être marqué possédé après l'achat")

	player.free()
	station.free()
	return failures


func _test_refuses_second_purchase_without_charge() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var station := PERK_STATION.new()
	station.configure(PERK_CONSTITUTION)
	tree.root.add_child(station)

	GameSession.start_new_session()
	GameSession.add_credits(station.price_credits)
	station.interact(player)

	GameSession.add_credits(station.price_credits)
	if station.interact(player):
		failures.append("un second achat du même avantage doit être refusé")
	if GameSession.get_credits() != station.price_credits:
		failures.append("un achat refusé ne doit pas débiter de crédits")

	player.free()
	station.free()
	return failures
