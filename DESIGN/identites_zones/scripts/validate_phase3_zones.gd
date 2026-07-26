extends SceneTree

const EXPECTED_ZONES := {
	"np_z03_zone_accueil.glb": "NP_Z03_ZONE_A_ACCUEIL",
	"np_z03_zone_confinement.glb": "NP_Z03_ZONE_C_CONFINEMENT",
	"np_z03_zone_entrepot_medical.glb": "NP_Z03_ZONE_M_ENTREPOT_MEDICAL",
	"np_z03_zone_synthese.glb": "NP_Z03_ZONE_S_SYNTHESE",
	"np_z03_zone_extraction.glb": "NP_Z03_ZONE_E_EXTRACTION",
}


func _init() -> void:
	var export_path := ProjectSettings.globalize_path("res://zones/exports")
	var mesh_total := 0
	for file_name: String in EXPECTED_ZONES:
		var document := GLTFDocument.new()
		var state := GLTFState.new()
		var path := export_path.path_join(file_name)
		if document.append_from_file(path, state) != OK:
			_fail("Zone illisible : %s" % file_name)
			return
		var zone := document.generate_scene(state) as Node3D
		if zone == null or zone.name != EXPECTED_ZONES[file_name]:
			_fail("Racine invalide : %s" % file_name)
			return
		var meshes := _count_meshes(zone)
		if meshes == 0 or _has_functional_node(zone):
			_fail("Contenu invalide : %s" % file_name)
			return
		mesh_total += meshes
		zone.queue_free()
	print("NOX_PROTOCOL_PHASE3_ZONE_VALIDATION_READY count=%d meshes=%d" % [EXPECTED_ZONES.size(), mesh_total])
	quit(0)


func _count_meshes(node: Node) -> int:
	var count := 1 if node is MeshInstance3D else 0
	for child: Node in node.get_children():
		count += _count_meshes(child)
	return count


func _has_functional_node(node: Node) -> bool:
	if node is CollisionObject3D or node is NavigationRegion3D or node is AnimationPlayer:
		return true
	for child: Node in node.get_children():
		if _has_functional_node(child):
			return true
	return false


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
