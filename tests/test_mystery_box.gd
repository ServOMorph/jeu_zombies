extends RefCounted

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const MYSTERY_BOX := preload("res://world/mystery_box.gd")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const PLAYER := preload("res://player/player.tscn")
const MYSTERY_BOX_ENTREPOT := preload("res://data/weapons/mystery_box_entrepot.tres")
const WALL_BUY_FRELON := preload("res://data/weapons/wall_buy_couloirs_frelon.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_blockout_wiring())
	failures.append_array(_test_purchase_and_confirmation_flow())
	failures.append_array(_test_exclusion_and_distribution())
	failures.append_array(_test_session_reset_clears_pending_state())
	GameSession.return_to_menu()
	return failures


func _test_blockout_wiring() -> Array[String]:
	var failures: Array[String] = []
	var expected_ids := PackedStringArray(["entrepot_caisse"])
	if HELIX_BLOCKOUT.get_mystery_box_ids() != expected_ids:
		failures.append("le blockout doit déclarer la caisse aléatoire en zone avancée")

	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout") as HelixBlockout
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	elif blockout.get_mystery_box("entrepot_caisse") == null:
		failures.append("la caisse aléatoire de l'entrepôt doit exister dans le blockout")
	world.free()
	return failures


func _test_purchase_and_confirmation_flow() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)
	var weapon_controller = player.weapon_controller

	var box := MYSTERY_BOX.new()
	box.configure(MYSTERY_BOX_ENTREPOT)
	tree.root.add_child(box)

	GameSession.start_new_session()

	if box.interact(player):
		failures.append("l'activation sans crédits suffisants doit être refusée")
	if GameSession.get_credits() != 0:
		failures.append("une activation refusée ne doit pas modifier les crédits")

	GameSession.add_credits(box.price_credits)
	if not box.interact(player):
		failures.append("l'activation avec assez de crédits doit réussir")
	if GameSession.get_credits() != 0:
		failures.append("l'activation doit débiter exactement son prix une seule fois")

	if box.interact(player):
		failures.append("une nouvelle activation pendant le tirage ne doit rien débiter ni résoudre")
	GameSession.add_credits(box.price_credits)
	if box.interact(player):
		failures.append("une activation pendant le tirage doit être refusée même avec des crédits")
	GameSession.add_credits(-GameSession.get_credits())

	box.resolve_spin()
	var drawn_weapon: Resource = box._drawn_weapon
	if not box.interact(player):
		failures.append("la confirmation après le tirage doit attribuer l'arme")
	if weapon_controller.find_slot_for_definition(drawn_weapon) == -1:
		failures.append("l'arme tirée doit être assignée à un emplacement du joueur après confirmation")

	player.free()
	box.free()
	return failures


func _test_exclusion_and_distribution() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree

	var player := PLAYER.instantiate()
	tree.root.add_child(player)
	var weapon_controller = player.weapon_controller

	var box := MYSTERY_BOX.new()
	box.configure(MYSTERY_BOX_ENTREPOT)
	tree.root.add_child(box)

	var frelon_definition = WALL_BUY_FRELON.get("weapon")
	weapon_controller.configure_slots(frelon_definition)
	weapon_controller.equip_slot(0)

	var seen_other_than_current := false
	var seen: Dictionary = {}
	for i in 200:
		var drawn := box.pick_weapon(weapon_controller)
		seen[drawn] = true
		if drawn != frelon_definition:
			seen_other_than_current = true

	if seen.has(frelon_definition):
		failures.append("la caisse ne doit pas donner l'arme actuellement tenue tant que d'autres résultats existent")
	if not seen_other_than_current:
		failures.append("le tirage doit pouvoir produire un résultat différent de l'arme tenue")
	for weapon: Resource in box.possible_weapons:
		if weapon == frelon_definition:
			continue
		if not seen.has(weapon):
			failures.append("le résultat %s doit pouvoir apparaître dans le tirage" % str(weapon.get("weapon_name")))

	player.free()
	box.free()
	return failures


func _test_session_reset_clears_pending_state() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)

	var box := MYSTERY_BOX.new()
	box.configure(MYSTERY_BOX_ENTREPOT)
	tree.root.add_child(box)

	GameSession.start_new_session()
	GameSession.add_credits(box.price_credits)
	box.interact(player)
	box.resolve_spin()

	GameSession.return_to_menu()
	if box._state != MYSTERY_BOX.State.IDLE:
		failures.append("la remise à zéro de session doit annuler une confirmation de caisse en attente")

	player.free()
	box.free()
	return failures
