extends RefCounted

const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
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
		if not helix_blockout.are_all_doors_open():
			failures.append("les portes doivent être ouvertes par défaut pendant le blockout")
		if not helix_blockout.can_navigate_between("accueil", "extraction"):
			failures.append("les cinq zones doivent être reliées lorsque les portes sont ouvertes")
		helix_blockout.set_all_doors_open(false)
		if helix_blockout.can_navigate_between("accueil", "extraction"):
			failures.append("la navigation entre zones doit être bloquée lorsque les portes sont fermées")
		for door_id: String in expected_door_ids:
			var door := helix_blockout.get_door(door_id)
			if door == null:
				failures.append("la porte %s doit exister" % door_id)
				continue
			if door.is_open:
				failures.append("la porte %s doit mémoriser son état fermé" % door_id)
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
	for zone_id: String in expected_zone_ids:
		if not spawn_zone_ids.has(zone_id):
			failures.append("chaque zone du blockout doit avoir un point d'apparition")
			break
	world.free()
	return failures
