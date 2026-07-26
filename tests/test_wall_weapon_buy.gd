extends RefCounted

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const WALL_WEAPON_BUY := preload("res://world/wall_weapon_buy.gd")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const PLAYER := preload("res://player/player.tscn")
const WALL_BUY_FRELON := preload("res://data/weapons/wall_buy_couloirs_frelon.tres")
const WALL_BUY_SENTINELLE := preload("res://data/weapons/wall_buy_laboratoire_sentinelle.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_blockout_wiring())
	failures.append_array(_test_purchase_flow())
	GameSession.return_to_menu()
	return failures


func _test_blockout_wiring() -> Array[String]:
	var failures: Array[String] = []
	var expected_ids := PackedStringArray([
		"accueil_pistolet", "couloirs_frelon", "entrepot_foudroyeur",
		"laboratoire_sentinelle", "extraction_oeil_de_nox", "extraction_broyeur",
	])
	if HELIX_BLOCKOUT.get_wall_buy_ids() != expected_ids:
		failures.append("le blockout doit déclarer les six achats muraux d'armes dans l'ordre")

	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout") as HelixBlockout
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	else:
		for buy_id: String in expected_ids:
			var buy := blockout.get_wall_buy(buy_id)
			if buy == null:
				failures.append("l'achat mural %s doit exister" % buy_id)
	world.free()
	return failures


func _test_purchase_flow() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)
	var weapon_controller = player.weapon_controller

	var frelon_definition = WALL_BUY_FRELON.get("weapon")
	var sentinelle_definition = WALL_BUY_SENTINELLE.get("weapon")

	var buy_frelon := WALL_WEAPON_BUY.new()
	buy_frelon.configure(WALL_BUY_FRELON)
	tree.root.add_child(buy_frelon)

	var buy_sentinelle := WALL_WEAPON_BUY.new()
	buy_sentinelle.configure(WALL_BUY_SENTINELLE)
	tree.root.add_child(buy_sentinelle)

	GameSession.start_new_session()

	if buy_frelon.interact(player):
		failures.append("l'achat sans crédits suffisants doit être refusé")
	if GameSession.get_credits() != 0:
		failures.append("un achat refusé ne doit pas modifier les crédits")

	GameSession.add_credits(buy_frelon.price_credits)
	if not buy_frelon.interact(player):
		failures.append("l'achat initial doit réussir avec assez de crédits et un emplacement libre")
	var frelon_slot: int = weapon_controller.find_slot_for_definition(frelon_definition)
	if frelon_slot == -1:
		failures.append("l'arme achetée doit être assignée à un emplacement du joueur")
	elif weapon_controller.active_slot != frelon_slot:
		failures.append("l'arme achetée doit devenir l'arme active immédiatement")
	if GameSession.get_credits() != 0:
		failures.append("l'achat initial doit débiter exactement son prix")

	weapon_controller.equip_slot(frelon_slot)
	for i in frelon_definition.magazine_capacity:
		weapon_controller.try_fire(Vector3.ZERO, Vector3.FORWARD)
		weapon_controller.tick(frelon_definition.fire_interval_seconds)
	weapon_controller.start_reload()
	weapon_controller.tick(frelon_definition.reload_duration_seconds)
	if weapon_controller.get_slot_ammo(frelon_slot).y >= frelon_definition.reserve_capacity:
		failures.append("un rechargement doit consommer la réserve avant le test de rachat")

	if not buy_frelon.can_interact(player):
		failures.append("le rachat de munitions doit être proposé quand la réserve n'est pas pleine")
	GameSession.add_credits(buy_frelon.ammo_price_credits)
	if not buy_frelon.interact(player):
		failures.append("le rachat de munitions doit réussir avec assez de crédits")
	if weapon_controller.get_slot_ammo(frelon_slot).y != frelon_definition.reserve_capacity:
		failures.append("le rachat de munitions doit remplir la réserve sans dépasser sa capacité")
	if GameSession.get_credits() != 0:
		failures.append("le rachat de munitions doit débiter exactement son prix")

	GameSession.add_credits(buy_frelon.ammo_price_credits)
	if buy_frelon.can_interact(player) or buy_frelon.interact(player):
		failures.append("un rachat de munitions avec la réserve déjà pleine doit être refusé")
	if GameSession.get_credits() != buy_frelon.ammo_price_credits:
		failures.append("un achat refusé pour réserve pleine ne doit pas débiter de crédits")

	GameSession.return_to_menu()
	GameSession.start_new_session()
	GameSession.add_credits(buy_sentinelle.price_credits)
	if not buy_sentinelle.interact(player):
		failures.append("le premier appui sur une arme murale sans emplacement libre doit être accepté pour armer la confirmation")
	if weapon_controller.find_slot_for_definition(sentinelle_definition) != -1:
		failures.append("le premier appui ne doit pas encore remplacer l'arme active")
	if GameSession.get_credits() != buy_sentinelle.price_credits:
		failures.append("armer la confirmation ne doit pas débiter de crédits")

	var active_slot_before: int = weapon_controller.active_slot
	if not buy_sentinelle.interact(player):
		failures.append("la confirmation doit réussir avec les crédits nécessaires")
	if weapon_controller.find_slot_for_definition(sentinelle_definition) != active_slot_before:
		failures.append("la confirmation doit remplacer l'arme active par la nouvelle arme")
	if GameSession.get_credits() != 0:
		failures.append("la confirmation doit débiter le prix de l'arme")

	GameSession.add_credits(buy_frelon.price_credits)
	if not buy_frelon.interact(player):
		failures.append("le premier appui doit s'armer même pour une arme déjà possédée précédemment")
	buy_frelon.on_target_lost()
	if not buy_frelon.interact(player):
		failures.append("un nouvel appui après perte de cible doit réarmer la confirmation plutôt que l'exécuter")
	if weapon_controller.find_slot_for_definition(frelon_definition) != -1:
		failures.append("perdre la cible doit réinitialiser une confirmation en attente")
	if GameSession.get_credits() != buy_frelon.price_credits:
		failures.append("réarmer la confirmation après une perte de cible ne doit pas débiter de crédits")

	player.free()
	buy_frelon.free()
	buy_sentinelle.free()
	return failures
