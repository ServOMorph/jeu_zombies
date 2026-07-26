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
	var world := DEV_PLAYER_TEST.instantiate()
	var blockout := world.get_node_or_null("HelixBlockout")
	if blockout == null:
		failures.append("la scène de survie doit inclure le blockout d'Helix-9")
	var floor_collision := world.get_node_or_null("Floor/CollisionShape3D") as CollisionShape3D
	if floor_collision == null or not floor_collision.shape is BoxShape3D:
		failures.append("le blockout doit avoir un sol collisionnable")
	else:
		var floor_shape := floor_collision.shape as BoxShape3D
		if floor_shape.size.z < 140.0:
			failures.append("le sol du blockout doit couvrir la Salle d'extraction")
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
