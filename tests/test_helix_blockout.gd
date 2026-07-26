extends RefCounted

const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const FIRST_DOOR_POSITION := Vector3(0.0, 0.0, -5.0)
const FIRST_DOOR_CLEARANCE_METERS := 12.0


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var legacy_test_geometry := PackedStringArray([
		"NavigationObstacle",
		"LeftWall",
		"RightWall",
		"Step",
		"LowCeiling",
		"GentleSlope30",
		"SteepSlope55",
	])
	var expected_zone_ids := PackedStringArray([
		"accueil",
		"couloirs",
		"entrepot",
		"laboratoire",
		"extraction",
	])
	if HELIX_BLOCKOUT.get_zone_ids() != expected_zone_ids:
		failures.append("le blockout doit déclarer les cinq zones d'Helix-9 dans l'ordre")
	var expected_door_ids := PackedStringArray([
		"accueil_couloirs",
		"couloirs_entrepot",
		"couloirs_laboratoire",
		"entrepot_extraction",
		"laboratoire_extraction",
	])
	if HELIX_BLOCKOUT.get_door_ids() != expected_door_ids:
		failures.append("le blockout doit déclarer les cinq portes entre les zones")
	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var blockout := world.get_node_or_null("HelixBlockout")
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	else:
		var helix_blockout := blockout as HelixBlockout
		if helix_blockout.are_all_doors_open():
			failures.append("les portes achetables doivent être fermées au début de la session")
		if helix_blockout.can_navigate_between("accueil", "extraction"):
			failures.append("la navigation doit être bloquée avant l'achat des portes")
		helix_blockout.set_all_doors_open(true)
		if not helix_blockout.can_navigate_between("accueil", "extraction"):
			failures.append("les cinq zones doivent être reliées lorsque les portes sont ouvertes")
		helix_blockout.set_all_doors_open(false)
		for door_id: String in expected_door_ids:
			var door := helix_blockout.get_door(door_id)
			if door == null:
				failures.append("la porte %s doit exister" % door_id)
				continue
			if door.is_open:
				failures.append("la porte %s doit mémoriser son état fermé" % door_id)
	GameSession.return_to_menu()
	GameSession.start_new_session()
	if blockout != null:
		var helix_blockout := blockout as HelixBlockout
		for door_id: String in expected_door_ids:
			var door := helix_blockout.get_door(door_id)
			if door == null:
				continue
			var price := door.price_credits
			if door.interact(null) or door.is_open:
				failures.append("la porte %s doit refuser un achat sans crédits" % door_id)
				break
			if not GameSession.add_credits(price):
				failures.append("le test doit pouvoir créditer le prix de la porte %s" % door_id)
				break
			if not door.interact(null) or not door.is_open:
				failures.append("la porte %s doit s'ouvrir après un achat solvable" % door_id)
				break
			if GameSession.get_credits() != 0:
				failures.append("la porte %s doit débiter exactement son prix" % door_id)
				break
			if door.interact(null):
				failures.append("la porte %s ne doit pas pouvoir être achetée deux fois" % door_id)
				break
		if not helix_blockout.are_all_doors_open():
			failures.append("chaque porte doit rester ouverte après son achat")
		if not helix_blockout.can_navigate_between("accueil", "extraction"):
			failures.append("les achats doivent rétablir la navigation entre toutes les zones")
	GameSession.return_to_menu()
	for node_name: String in legacy_test_geometry:
		var test_geometry := world.get_node_or_null(node_name) as Node3D
		if test_geometry == null:
			failures.append("test geometry %s must exist" % node_name)
			break
		var horizontal_distance := Vector2(
			test_geometry.global_position.x - FIRST_DOOR_POSITION.x,
			test_geometry.global_position.z - FIRST_DOOR_POSITION.z
		).length()
		if horizontal_distance < FIRST_DOOR_CLEARANCE_METERS:
			failures.append("test geometry %s must not block the first door" % node_name)
			break
	for zone_id: String in expected_zone_ids:
		var floor_collision := world.get_node_or_null(
			"HelixBlockout/Zone_%s/Floor/CollisionShape3D" % zone_id.capitalize()
		) as CollisionShape3D
		if floor_collision == null or not floor_collision.shape is BoxShape3D:
			failures.append("la zone %s doit avoir un sol collisionnable" % zone_id)
			break
	var spawn_zone_ids := {}
	for child: Node in world.get_children():
		if child is ZombieSpawnPoint:
			spawn_zone_ids[(child as ZombieSpawnPoint).zone_id] = true
			if (child as ZombieSpawnPoint).zone_id == "accueil":
				var spawn_position := (child as ZombieSpawnPoint).position
				if absf(spawn_position.x) > 10.0 or spawn_position.z < -1.0 or spawn_position.z > 16.0:
					failures.append("les apparitions de l'Accueil doivent rester avant la première porte")
					break
	for zone_id: String in expected_zone_ids:
		if not spawn_zone_ids.has(zone_id):
			failures.append("chaque zone du blockout doit avoir un point d'apparition")
			break
	world.free()
	return failures
