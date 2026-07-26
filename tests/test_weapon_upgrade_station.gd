extends RefCounted

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const WEAPON_UPGRADE_STATION := preload("res://world/weapon_upgrade_station.gd")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const PLAYER := preload("res://player/player.tscn")
const WEAPON_UPGRADE_STATION_LABORATOIRE := preload("res://data/weapons/weapon_upgrade_station_laboratoire.tres")
const WALL_BUY_FRELON := preload("res://data/weapons/wall_buy_couloirs_frelon.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_blockout_wiring())
	failures.append_array(_test_upgrade_flow())
	failures.append_array(_test_refuses_second_upgrade_without_charge())
	failures.append_array(_test_refuses_with_knife_active())
	GameSession.return_to_menu()
	return failures


func _test_blockout_wiring() -> Array[String]:
	var failures: Array[String] = []
	var expected_ids := PackedStringArray(["laboratoire_station"])
	if HELIX_BLOCKOUT.get_weapon_upgrade_station_ids() != expected_ids:
		failures.append("le blockout doit déclarer la station d'amélioration au Laboratoire de synthèse")

	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout") as HelixBlockout
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	elif blockout.get_weapon_upgrade_station("laboratoire_station") == null:
		failures.append("la station d'amélioration du Laboratoire doit exister dans le blockout")
	world.free()
	return failures


func _test_upgrade_flow() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)
	var weapon_controller = player.weapon_controller
	weapon_controller.configure_slots(WALL_BUY_FRELON.get("weapon"))
	weapon_controller.equip_slot(0)

	var station := WEAPON_UPGRADE_STATION.new()
	station.configure(WEAPON_UPGRADE_STATION_LABORATOIRE)
	tree.root.add_child(station)

	GameSession.start_new_session()

	if station.interact(player):
		failures.append("l'amélioration sans crédits suffisants doit être refusée")
	if GameSession.get_credits() != 0:
		failures.append("une amélioration refusée ne doit pas modifier les crédits")

	GameSession.add_credits(station.price_credits)
	if not station.interact(player):
		failures.append("l'amélioration avec assez de crédits doit réussir")
	if GameSession.get_credits() != 0:
		failures.append("l'amélioration doit débiter exactement son prix une seule fois")
	if not weapon_controller.is_slot_upgraded(0):
		failures.append("l'emplacement actif doit être marqué amélioré après l'interaction")

	player.free()
	station.free()
	return failures


func _test_refuses_second_upgrade_without_charge() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)
	var weapon_controller = player.weapon_controller
	weapon_controller.configure_slots(WALL_BUY_FRELON.get("weapon"))
	weapon_controller.equip_slot(0)

	var station := WEAPON_UPGRADE_STATION.new()
	station.configure(WEAPON_UPGRADE_STATION_LABORATOIRE)
	tree.root.add_child(station)

	GameSession.start_new_session()
	GameSession.add_credits(station.price_credits)
	station.interact(player)

	GameSession.add_credits(station.price_credits)
	if station.interact(player):
		failures.append("une seconde amélioration de la même arme doit être refusée")
	if GameSession.get_credits() != station.price_credits:
		failures.append("une amélioration refusée ne doit pas débiter de crédits")

	player.free()
	station.free()
	return failures


func _test_refuses_with_knife_active() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)
	var weapon_controller = player.weapon_controller
	weapon_controller.configure_slots(WALL_BUY_FRELON.get("weapon"))
	weapon_controller.select_knife()

	var station := WEAPON_UPGRADE_STATION.new()
	station.configure(WEAPON_UPGRADE_STATION_LABORATOIRE)
	tree.root.add_child(station)

	GameSession.start_new_session()
	GameSession.add_credits(station.price_credits)
	if station.interact(player):
		failures.append("l'amélioration doit être refusée quand le couteau est actif")
	if GameSession.get_credits() != station.price_credits:
		failures.append("une amélioration refusée avec le couteau actif ne doit pas débiter de crédits")

	player.free()
	station.free()
	return failures
