extends SceneTree

const EXPECTED_FILES := {
	"np_z03_accueil_banque.glb": "NP_Z03_ACC_01_BanqueAccueil",
	"np_z03_accueil_portillon.glb": "NP_Z03_ACC_02_Portillon",
	"np_z03_confinement_barriere.glb": "NP_Z03_CON_01_BarriereRepliee",
	"np_z03_medical_rayonnage.glb": "NP_Z03_MED_01_RayonnageBas",
	"np_z03_medical_bac.glb": "NP_Z03_MED_02_BacScelle",
	"np_z03_medical_chariot.glb": "NP_Z03_MED_03_ChariotMedical",
	"np_z03_synthese_paillasse.glb": "NP_Z03_SYN_01_Paillasse",
	"np_z03_synthese_cuve.glb": "NP_Z03_SYN_02_Cuve",
	"np_z03_synthese_console.glb": "NP_Z03_SYN_03_Console",
	"np_z03_synthese_observation.glb": "NP_Z03_SYN_04_Observation",
	"np_z03_extraction_balise.glb": "NP_Z03_EXT_01_BaliseExtraction",
	"np_z03_commun_cable_fixe.glb": "NP_Z03_COM_01_CableFixe",
	"np_z03_commun_equipement_mural.glb": "NP_Z03_COM_02_EquipementMural",
}


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
		if instance.name != EXPECTED_FILES[file_name]:
			_fail("Racine inattendue : %s" % file_name)
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
