extends RefCounted

const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const ZONE_WALLS := preload("res://world/zone_walls.gd")
const BAIE_HALF_WIDTH := 2.0
const CORNER_SEAL_PADDING := ZONE_WALLS.WALL_THICKNESS * 0.5


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)

	var zone_root := world.get_node_or_null("HelixBlockout/Zone_Couloirs") as Node3D
	if zone_root == null:
		failures.append("la zone couloirs doit exister")
		world.free()
		return failures

	_check_collision_boxes(zone_root, failures)
	_check_baie_and_corner_openings(zone_root, failures)
	_check_habillage_nodes(zone_root, failures)
	_check_habillage_footprints(zone_root, failures)

	world.free()
	return failures


func _check_collision_boxes(zone_root: Node3D, failures: Array[String]) -> void:
	var murs := zone_root.get_node_or_null("Murs") as Node3D
	if murs == null:
		failures.append("la zone couloirs doit avoir un conteneur de collision de murs")
		return
	var expected_boxes: Array = ZONE_WALLS.WALL_COLLISION_BOXES["couloirs"]
	if murs.get_child_count() != expected_boxes.size():
		failures.append(
			"la zone couloirs doit avoir %d boîtes de collision de mur, trouvé %d"
			% [expected_boxes.size(), murs.get_child_count()]
		)
	for box: Dictionary in expected_boxes:
		var body := murs.get_node_or_null("Mur_%s" % box["id"]) as StaticBody3D
		if body == null:
			failures.append("la boîte de collision Mur_%s doit exister" % box["id"])
			continue
		var collision := body.get_node_or_null("CollisionShape3D") as CollisionShape3D
		if collision == null or not collision.shape is BoxShape3D:
			failures.append("Mur_%s doit avoir une forme de collision boîte" % box["id"])
			continue
		var expected_center: Vector3 = (box["start"] as Vector3).lerp(box["end"] as Vector3, 0.5)
		if not body.position.is_equal_approx(Vector3(expected_center.x, body.position.y, expected_center.z)):
			failures.append("Mur_%s doit être centré sur le segment de mur attendu" % box["id"])


func _check_baie_and_corner_openings(zone_root: Node3D, failures: Array[String]) -> void:
	var murs := zone_root.get_node_or_null("Murs") as Node3D
	if murs == null:
		return
	var north_west := murs.get_node_or_null("Mur_nord_ouest") as StaticBody3D
	var north_east := murs.get_node_or_null("Mur_nord_est") as StaticBody3D
	if north_west != null and north_east != null:
		var west_shape := (north_west.get_node("CollisionShape3D") as CollisionShape3D).shape as BoxShape3D
		var east_shape := (north_east.get_node("CollisionShape3D") as CollisionShape3D).shape as BoxShape3D
		var west_max_x := north_west.position.x + west_shape.size.x * 0.5
		var east_min_x := north_east.position.x - east_shape.size.x * 0.5
		if west_max_x > -BAIE_HALF_WIDTH + CORNER_SEAL_PADDING + 0.01 or east_min_x < BAIE_HALF_WIDTH - CORNER_SEAL_PADDING - 0.01:
			failures.append("la baie nord doit rester libre de collision entre x=-2 et x=2")

	var south := murs.get_node_or_null("Mur_sud") as StaticBody3D
	if south != null:
		var south_shape := (south.get_node("CollisionShape3D") as CollisionShape3D).shape as BoxShape3D
		var south_half_length := south_shape.size.x * 0.5
		if south_half_length > 7.0 + CORNER_SEAL_PADDING + 0.01:
			failures.append("le mur sud ne doit pas empiéter sur les coins ouverts vers les couloirs en biais")

	for wall_id in ["ouest", "est"]:
		var wall := murs.get_node_or_null("Mur_%s" % wall_id) as StaticBody3D
		if wall == null:
			continue
		var shape := (wall.get_node("CollisionShape3D") as CollisionShape3D).shape as BoxShape3D
		var min_z := wall.position.z - shape.size.z * 0.5
		if min_z < -5.0 - CORNER_SEAL_PADDING - 0.01:
			failures.append("le mur %s ne doit pas descendre sous z=-5 (coin ouvert vers le couloir en biais)" % wall_id)


func _check_habillage_nodes(zone_root: Node3D, failures: Array[String]) -> void:
	var habillage := zone_root.get_node_or_null("Habillage") as Node3D
	if habillage == null:
		failures.append("la zone couloirs doit avoir un conteneur d'habillage")
		return
	var expected_names := PackedStringArray([
		"AngleExterieur_nord_ouest",
		"AngleExterieur_nord_est",
		"TerminaisonMur_sud_ouest",
		"TerminaisonMur_sud_est",
		"TerminaisonMur_ouest_sud",
		"TerminaisonMur_est_sud",
		"EncadrementSimple_accueil_couloirs",
	])
	for expected_name: String in expected_names:
		if habillage.get_node_or_null(expected_name) == null:
			failures.append("l'habillage de couloirs doit inclure %s" % expected_name)
	if habillage.get_child_count() < expected_names.size():
		failures.append("l'habillage de couloirs doit inclure les modules de mur tuilés")


# Contrôle d'emprise : la vérification par nom de nœud ne prouve rien sur la géométrie posée.
# Ces bornes attrapent les modules mal orientés ou mal ancrés, qui débordent hors de la dalle
# de sol ou obstruent la baie nord.
func _check_habillage_footprints(zone_root: Node3D, failures: Array[String]) -> void:
	var habillage := zone_root.get_node_or_null("Habillage") as Node3D
	if habillage == null:
		return
	var zone_half_x := 11.0 + ZONE_WALLS.WALL_THICKNESS
	var zone_half_z := 7.0 + ZONE_WALLS.WALL_THICKNESS
	var to_zone := zone_root.global_transform.affine_inverse()
	for child in habillage.get_children():
		var node_3d := child as Node3D
		if node_3d == null:
			continue
		var has := [false]
		var box := _module_aabb(node_3d, to_zone, AABB(), has)
		if not has[0]:
			continue
		var mn := box.position
		var mx := box.end
		if mn.x < -zone_half_x or mx.x > zone_half_x or mn.z < -zone_half_z or mx.z > zone_half_z:
			failures.append(
				"%s déborde de l'emprise de la zone : min(%.2f, %.2f) max(%.2f, %.2f)"
				% [node_3d.name, mn.x, mn.z, mx.x, mx.z]
			)
		if node_3d.name.begins_with("EncadrementSimple"):
			continue
		var overlaps_baie_x := mx.x > -BAIE_HALF_WIDTH + 0.01 and mn.x < BAIE_HALF_WIDTH - 0.01
		if overlaps_baie_x and mx.z > 6.5:
			failures.append(
				"%s obstrue la baie nord : min(%.2f, %.2f) max(%.2f, %.2f)"
				% [node_3d.name, mn.x, mn.z, mx.x, mx.z]
			)


func _module_aabb(node: Node, to_zone: Transform3D, accum: AABB, has: Array) -> AABB:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh != null:
			var box: AABB = to_zone * mesh_instance.global_transform * mesh_instance.mesh.get_aabb()
			if has[0]:
				accum = accum.merge(box)
			else:
				accum = box
				has[0] = true
	for child in node.get_children():
		accum = _module_aabb(child, to_zone, accum, has)
	return accum
