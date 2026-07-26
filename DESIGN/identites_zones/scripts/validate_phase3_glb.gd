extends SceneTree

const EXPECTED_FILES := [
	"np_z03_accueil_banque.glb",
	"np_z03_accueil_portillon.glb",
	"np_z03_confinement_barriere.glb",
	"np_z03_medical_rayonnage.glb",
	"np_z03_medical_bac.glb",
	"np_z03_synthese_paillasse.glb",
	"np_z03_synthese_cuve.glb",
	"np_z03_extraction_balise.glb",
	"np_z03_commun_cable_fixe.glb",
	"np_z03_commun_equipement_mural.glb",
]


func _init() -> void:
	var export_path := ProjectSettings.globalize_path("res://exports")
	var mesh_total := 0
	for file_name: String in EXPECTED_FILES:
		var file_path := export_path.path_join(file_name)
		if not FileAccess.file_exists(file_path):
			_fail("Export absent : %s" % file_name)
			return
		var document := GLTFDocument.new()
		var state := GLTFState.new()
		if document.append_from_file(file_path, state) != OK:
			_fail("GLB illisible : %s" % file_name)
			return
		var instance := document.generate_scene(state)
		if not instance is Node3D:
			_fail("Racine non 3D : %s" % file_name)
			return
		var meshes := _count_meshes(instance)
		if meshes == 0:
			_fail("Aucun mesh : %s" % file_name)
			return
		if _has_functional_node(instance):
			_fail("Composant fonctionnel interdit : %s" % file_name)
			return
		mesh_total += meshes
		instance.queue_free()
	print("NOX_PROTOCOL_PHASE3_GLB_VALIDATION_READY count=%d meshes=%d" % [EXPECTED_FILES.size(), mesh_total])
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
