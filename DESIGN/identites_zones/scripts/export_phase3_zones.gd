extends SceneTree

const KIT_PATH := "res://../kit_modulaire/exports"
const ASSET_PATH := "res://exports"
const OUTPUT_PATH := "res://zones/exports"


func _init() -> void:
	var output_path := ProjectSettings.globalize_path(OUTPUT_PATH).simplify_path()
	if DirAccess.make_dir_recursive_absolute(output_path) != OK:
		_fail("Création du dossier de zones impossible")
		return
	var zones: Array[Dictionary] = [
		{"file": "np_z03_zone_accueil", "node": _build_accueil()},
		{"file": "np_z03_zone_confinement", "node": _build_confinement()},
		{"file": "np_z03_zone_entrepot_medical", "node": _build_entrepot_medical()},
		{"file": "np_z03_zone_synthese", "node": _build_synthese()},
		{"file": "np_z03_zone_extraction", "node": _build_extraction()},
	]
	for zone: Dictionary in zones:
		if not _export_zone(zone.file, zone.node as Node3D, output_path):
			return
	print("NOX_PROTOCOL_PHASE3_ZONE_EXPORT_READY count=%d" % zones.size())
	quit(0)


func _build_accueil() -> Node3D:
	var root := _root("NP_Z03_ZONE_A_ACCUEIL")
	_add_room(root, 8, 8, 0.0, true)
	for z_position: float in [-3.0, 1.0, 5.0]:
		_add_asset(root, ASSET_PATH, "np_z03_accueil_banque.glb", Vector3(-6.9, 0.0, z_position), -90.0)
	_add_asset(root, ASSET_PATH, "np_z03_accueil_portillon.glb", Vector3(5.9, 0.0, 4.0), 90.0)
	_add_asset(root, ASSET_PATH, "np_z03_commun_equipement_mural.glb", Vector3(-7.88, 1.1, -4.0), 90.0)
	_add_asset(root, ASSET_PATH, "np_z03_commun_cable_fixe.glb", Vector3(0.0, 3.05, 6.8))
	return root


func _build_confinement() -> Node3D:
	var root := _root("NP_Z03_ZONE_C_CONFINEMENT")
	_add_room(root, 3, 12, 0.0, true)
	for z_position: float in [-9.0, -3.0, 3.0, 9.0]:
		_add_asset(root, ASSET_PATH, "np_z03_confinement_barriere.glb", Vector3(-2.6, 0.0, z_position), 90.0)
		_add_asset(root, ASSET_PATH, "np_z03_commun_equipement_mural.glb", Vector3(2.88, 1.1, z_position - 1.5), -90.0)
		_add_asset(root, ASSET_PATH, "np_z03_commun_cable_fixe.glb", Vector3(0.0, 3.05, z_position))
	_add_kit(root, "np_kms_15_porte_accueil_couloirs.glb", Vector3(0.0, 0.0, 12.1), 180.0)
	return root


func _build_entrepot_medical() -> Node3D:
	var root := _root("NP_Z03_ZONE_M_ENTREPOT_MEDICAL")
	_add_room(root, 8, 10, 0.0, true)
	for z_position: float in [-7.0, -3.0, 1.0, 5.0]:
		_add_asset(root, ASSET_PATH, "np_z03_medical_rayonnage.glb", Vector3(-7.1, 0.0, z_position), 90.0)
		_add_asset(root, ASSET_PATH, "np_z03_medical_rayonnage.glb", Vector3(7.1, 0.0, z_position), -90.0)
		_add_asset(root, ASSET_PATH, "np_z03_medical_bac.glb", Vector3(-7.1, 0.88, z_position), 90.0)
		_add_asset(root, ASSET_PATH, "np_z03_medical_bac.glb", Vector3(7.1, 0.88, z_position), -90.0)
	_add_asset(root, ASSET_PATH, "np_z03_medical_chariot.glb", Vector3(-4.8, 0.0, -6.0), 90.0)
	_add_asset(root, ASSET_PATH, "np_z03_medical_chariot.glb", Vector3(4.8, 0.0, 6.0), -90.0)
	return root


func _build_synthese() -> Node3D:
	var root := _root("NP_Z03_ZONE_S_SYNTHESE")
	_add_room(root, 8, 8, 0.0, true)
	for z_position: float in [-3.0, 3.0]:
		_add_asset(root, ASSET_PATH, "np_z03_synthese_paillasse.glb", Vector3(-6.9, 0.0, z_position), -90.0)
		_add_asset(root, ASSET_PATH, "np_z03_synthese_cuve.glb", Vector3(6.7, 0.0, z_position), 90.0)
		_add_asset(root, ASSET_PATH, "np_z03_commun_cable_fixe.glb", Vector3(0.0, 3.05, z_position))
	_add_asset(root, ASSET_PATH, "np_z03_synthese_console.glb", Vector3(7.65, 0.0, -0.5), -90.0)
	_add_asset(root, ASSET_PATH, "np_z03_synthese_observation.glb", Vector3(7.86, 0.0, 5.0), -90.0)
	return root


func _build_extraction() -> Node3D:
	var root := _root("NP_Z03_ZONE_E_EXTRACTION")
	_add_room(root, 10, 10, 0.0, false)
	for z_position: float in [-7.0, 0.0, 7.0]:
		_add_asset(root, ASSET_PATH, "np_z03_extraction_balise.glb", Vector3(-8.8, 0.0, z_position))
		_add_asset(root, ASSET_PATH, "np_z03_extraction_balise.glb", Vector3(8.8, 0.0, z_position))
		_add_asset(root, ASSET_PATH, "np_z03_commun_equipement_mural.glb", Vector3(-9.88, 1.1, z_position), 90.0)
		_add_asset(root, ASSET_PATH, "np_z03_commun_equipement_mural.glb", Vector3(9.88, 1.1, z_position), -90.0)
	return root


func _root(node_name: String) -> Node3D:
	var root := Node3D.new()
	root.name = node_name
	return root


func _add_room(root: Node3D, width_cells: int, depth_cells: int, center_z: float, ceiling: bool) -> void:
	var half_width := float(width_cells - 1)
	var half_depth := float(depth_cells - 1)
	for x_index: int in range(width_cells):
		for z_index: int in range(depth_cells):
			var position := Vector3((float(x_index) * 2.0) - half_width, 0.0, (float(z_index) * 2.0) - half_depth + center_z)
			_add_kit(root, "np_kms_01_sol_droit.glb", position)
			if ceiling:
				_add_kit(root, "np_kms_11_plafond_technique.glb", position + Vector3(0.0, 3.5, 0.0))
	for z_index: int in range(depth_cells):
		var z_position := (float(z_index) * 2.0) - half_depth + center_z
		_add_kit(root, "np_kms_05_mur_plein.glb", Vector3(-float(width_cells), 0.0, z_position), 90.0)
		_add_kit(root, "np_kms_05_mur_plein.glb", Vector3(float(width_cells), 0.0, z_position), -90.0)
	for x_index: int in range(width_cells):
		var x_position := (float(x_index) * 2.0) - half_width
		_add_kit(root, "np_kms_05_mur_plein.glb", Vector3(x_position, 0.0, -float(depth_cells) + center_z), 0.0)
		_add_kit(root, "np_kms_05_mur_plein.glb", Vector3(x_position, 0.0, float(depth_cells) + center_z), 180.0)


func _add_kit(root: Node3D, file_name: String, position: Vector3, rotation_y: float = 0.0) -> void:
	_add_asset(root, KIT_PATH, file_name, position, rotation_y)


func _add_asset(root: Node3D, folder: String, file_name: String, position: Vector3, rotation_y: float = 0.0) -> void:
	var node := _load_glb(ProjectSettings.globalize_path("%s/%s" % [folder, file_name]).simplify_path())
	if node == null:
		_fail("Source introuvable ou incompatible : %s" % file_name)
		return
	node.position = position
	node.rotation_degrees.y = rotation_y
	root.add_child(node)


func _load_glb(path: String) -> Node3D:
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_file(path, state) != OK:
		return null
	var scene := document.generate_scene(state)
	if scene is Node3D:
		return scene as Node3D
	if scene != null:
		scene.queue_free()
	return null


func _export_zone(file_name: String, node: Node3D, output_path: String) -> bool:
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_scene(node, state) != OK:
		node.queue_free()
		_fail("Export impossible : %s" % file_name)
		return false
	var error := document.write_to_filesystem(state, output_path.path_join("%s.glb" % file_name))
	node.queue_free()
	if error != OK:
		_fail("Écriture impossible : %s" % file_name)
		return false
	return true


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
