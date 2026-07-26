extends SceneTree

var steel_dark: StandardMaterial3D
var steel_painted: StandardMaterial3D
var clinical: StandardMaterial3D
var cyan: StandardMaterial3D
var amber: StandardMaterial3D
var red: StandardMaterial3D


func _init() -> void:
	_create_materials()
	var output_path := ProjectSettings.globalize_path("res://exports")
	if DirAccess.make_dir_recursive_absolute(output_path) != OK:
		_fail("Création du dossier d'exports impossible")
		return
	var assets: Array[Dictionary] = [
		{"file": "np_z03_accueil_banque", "node": _build_accueil_banque()},
		{"file": "np_z03_accueil_portillon", "node": _build_accueil_portillon()},
		{"file": "np_z03_confinement_barriere", "node": _build_confinement_barriere()},
		{"file": "np_z03_medical_rayonnage", "node": _build_medical_rayonnage()},
		{"file": "np_z03_medical_bac", "node": _build_medical_bac()},
		{"file": "np_z03_medical_chariot", "node": _build_medical_chariot()},
		{"file": "np_z03_synthese_paillasse", "node": _build_synthese_paillasse()},
		{"file": "np_z03_synthese_cuve", "node": _build_synthese_cuve()},
		{"file": "np_z03_synthese_console", "node": _build_synthese_console()},
		{"file": "np_z03_synthese_observation", "node": _build_synthese_observation()},
		{"file": "np_z03_extraction_balise", "node": _build_extraction_balise()},
		{"file": "np_z03_commun_cable_fixe", "node": _build_cable_fixe()},
		{"file": "np_z03_commun_equipement_mural", "node": _build_equipement_mural()},
	]
	for asset: Dictionary in assets:
		if not _export_asset(asset.file, asset.node as Node3D, output_path):
			return
	print("NOX_PROTOCOL_PHASE3_GLB_EXPORT_READY count=%d" % assets.size())
	quit(0)


func _create_materials() -> void:
	steel_dark = _material(Color("#111820"), 0.68, 0.32)
	steel_painted = _material(Color("#7d8992"), 0.58, 0.25)
	clinical = _material(Color("#d7e0e2"), 0.76, 0.0)
	cyan = _material(Color("#40d5db"), 0.5, 0.05, Color("#40d5db") * 0.2)
	amber = _material(Color("#f0a43a"), 0.52, 0.05, Color("#f0a43a") * 0.22)
	red = _material(Color("#d94b4b"), 0.52, 0.05, Color("#d94b4b") * 0.18)


func _material(color: Color, roughness: float, metallic: float, emission: Color = Color.BLACK) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	if emission != Color.BLACK:
		material.emission_enabled = true
		material.emission = emission
	return material


func _root(node_name: String) -> Node3D:
	var root := Node3D.new()
	root.name = node_name
	return root


func _box(parent: Node3D, node_name: String, size: Vector3, position: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = material
	instance.mesh = mesh
	instance.position = position
	parent.add_child(instance)


func _build_accueil_banque() -> Node3D:
	var root := _root("NP_Z03_ACC_01_BanqueAccueil")
	_box(root, "Corps", Vector3(2.4, 0.75, 0.65), Vector3(0, 0.375, 0), clinical)
	_box(root, "Socle", Vector3(2.35, 0.12, 0.75), Vector3(0, 0.06, 0), steel_dark)
	_box(root, "Plan", Vector3(2.45, 0.08, 0.72), Vector3(0, 0.79, 0), steel_painted)
	_box(root, "Bandeau", Vector3(1.7, 0.06, 0.03), Vector3(0, 0.52, -0.34), cyan)
	return root


func _build_accueil_portillon() -> Node3D:
	var root := _root("NP_Z03_ACC_02_Portillon")
	_box(root, "MontantGauche", Vector3(0.12, 1.05, 0.15), Vector3(-0.54, 0.525, 0), steel_dark)
	_box(root, "MontantDroit", Vector3(0.12, 1.05, 0.15), Vector3(0.54, 0.525, 0), steel_dark)
	_box(root, "Bras", Vector3(1.08, 0.08, 0.08), Vector3(0, 0.72, 0), steel_painted)
	_box(root, "Voyant", Vector3(0.08, 0.16, 0.04), Vector3(-0.54, 0.85, -0.09), cyan)
	return root


func _build_confinement_barriere() -> Node3D:
	var root := _root("NP_Z03_CON_01_BarriereRepliee")
	_box(root, "Pied", Vector3(1.0, 0.12, 0.18), Vector3(0, 0.06, 0), steel_dark)
	_box(root, "CadreBas", Vector3(0.86, 0.08, 0.10), Vector3(0, 0.25, 0), steel_painted)
	_box(root, "CadreHaut", Vector3(0.86, 0.08, 0.10), Vector3(0, 0.72, 0), steel_painted)
	_box(root, "MontantGauche", Vector3(0.08, 0.55, 0.10), Vector3(-0.39, 0.49, 0), steel_painted)
	_box(root, "MontantDroit", Vector3(0.08, 0.55, 0.10), Vector3(0.39, 0.49, 0), steel_painted)
	_box(root, "Marqueur", Vector3(0.42, 0.10, 0.02), Vector3(0, 0.49, -0.06), amber)
	return root


func _build_medical_rayonnage() -> Node3D:
	var root := _root("NP_Z03_MED_01_RayonnageBas")
	_box(root, "MontantGauche", Vector3(0.08, 0.85, 0.50), Vector3(-0.86, 0.425, 0), steel_dark)
	_box(root, "MontantDroit", Vector3(0.08, 0.85, 0.50), Vector3(0.86, 0.425, 0), steel_dark)
	for height: float in [0.08, 0.40, 0.78]:
		_box(root, "Plateau", Vector3(1.8, 0.06, 0.50), Vector3(0, height, 0), steel_painted)
	return root


func _build_medical_bac() -> Node3D:
	var root := _root("NP_Z03_MED_02_BacScelle")
	_box(root, "Corps", Vector3(0.60, 0.28, 0.40), Vector3(0, 0.14, 0), clinical)
	_box(root, "Couvercle", Vector3(0.62, 0.07, 0.42), Vector3(0, 0.315, 0), steel_painted)
	_box(root, "Poignee", Vector3(0.18, 0.08, 0.04), Vector3(0, 0.19, -0.22), cyan)
	return root


func _build_medical_chariot() -> Node3D:
	var root := _root("NP_Z03_MED_03_ChariotMedical")
	_box(root, "PlateauBas", Vector3(1.10, 0.08, 0.55), Vector3(0, 0.32, 0), steel_painted)
	_box(root, "PlateauHaut", Vector3(1.10, 0.08, 0.55), Vector3(0, 0.82, 0), clinical)
	for x_position: float in [-0.47, 0.47]:
		for z_position: float in [-0.20, 0.20]:
			_box(root, "Roue", Vector3(0.12, 0.12, 0.12), Vector3(x_position, 0.10, z_position), steel_dark)
	_box(root, "Poignee", Vector3(0.08, 0.62, 0.08), Vector3(0.47, 0.60, 0), steel_painted)
	_box(root, "Bac", Vector3(0.48, 0.18, 0.30), Vector3(-0.18, 0.95, 0), clinical)
	return root


func _build_synthese_paillasse() -> Node3D:
	var root := _root("NP_Z03_SYN_01_Paillasse")
	_box(root, "Plan", Vector3(2.0, 0.10, 0.65), Vector3(0, 0.90, 0), clinical)
	_box(root, "Corps", Vector3(1.85, 0.78, 0.55), Vector3(0, 0.39, 0), steel_painted)
	_box(root, "Socle", Vector3(1.92, 0.10, 0.62), Vector3(0, 0.05, 0), steel_dark)
	_box(root, "Bandeau", Vector3(1.20, 0.05, 0.03), Vector3(0, 0.58, -0.295), cyan)
	return root


func _build_synthese_cuve() -> Node3D:
	var root := _root("NP_Z03_SYN_02_Cuve")
	_box(root, "Socle", Vector3(0.90, 0.16, 0.90), Vector3(0, 0.08, 0), steel_dark)
	_box(root, "Corps", Vector3(0.68, 1.66, 0.68), Vector3(0, 0.99, 0), clinical)
	_box(root, "CadreHaut", Vector3(0.82, 0.12, 0.82), Vector3(0, 1.88, 0), steel_painted)
	_box(root, "VoyantGauche", Vector3(0.05, 0.13, 0.03), Vector3(-0.27, 1.70, -0.355), red)
	_box(root, "VoyantDroit", Vector3(0.05, 0.13, 0.03), Vector3(0.27, 1.70, -0.355), red)
	return root


func _build_synthese_console() -> Node3D:
	var root := _root("NP_Z03_SYN_03_Console")
	_box(root, "Socle", Vector3(0.80, 0.12, 0.45), Vector3(0, 0.06, 0), steel_dark)
	_box(root, "Colonne", Vector3(0.52, 0.90, 0.32), Vector3(0, 0.51, 0.06), steel_painted)
	_box(root, "Ecran", Vector3(0.62, 0.34, 0.05), Vector3(0, 1.02, -0.14), cyan)
	_box(root, "VoyantAlerte", Vector3(0.06, 0.06, 0.02), Vector3(0.22, 0.78, -0.12), red)
	return root


func _build_synthese_observation() -> Node3D:
	var root := _root("NP_Z03_SYN_04_Observation")
	_box(root, "CadreBas", Vector3(1.40, 0.12, 0.18), Vector3(0, 0.06, 0), steel_dark)
	_box(root, "CadreHaut", Vector3(1.40, 0.12, 0.18), Vector3(0, 2.28, 0), steel_dark)
	_box(root, "MontantGauche", Vector3(0.12, 2.10, 0.18), Vector3(-0.64, 1.17, 0), steel_painted)
	_box(root, "MontantDroit", Vector3(0.12, 2.10, 0.18), Vector3(0.64, 1.17, 0), steel_painted)
	_box(root, "VitrageRenforce", Vector3(1.12, 1.92, 0.04), Vector3(0, 1.17, -0.11), clinical)
	_box(root, "BaliseConfinement", Vector3(0.28, 0.08, 0.03), Vector3(0, 2.05, -0.13), red)
	return root


func _build_extraction_balise() -> Node3D:
	var root := _root("NP_Z03_EXT_01_BaliseExtraction")
	_box(root, "Socle", Vector3(0.35, 0.12, 0.25), Vector3(0, 0.06, 0), steel_dark)
	_box(root, "Montant", Vector3(0.22, 2.16, 0.18), Vector3(0, 1.14, 0), steel_painted)
	_box(root, "Panneau", Vector3(0.28, 0.72, 0.04), Vector3(0, 1.45, -0.11), cyan)
	_box(root, "Tete", Vector3(0.30, 0.12, 0.23), Vector3(0, 2.34, 0), steel_dark)
	return root


func _build_cable_fixe() -> Node3D:
	var root := _root("NP_Z03_COM_01_CableFixe")
	_box(root, "Troncon", Vector3(2.0, 0.08, 0.08), Vector3(0, 0, 0), steel_dark)
	_box(root, "BrideGauche", Vector3(0.08, 0.14, 0.12), Vector3(-0.72, 0, 0), steel_painted)
	_box(root, "BrideDroite", Vector3(0.08, 0.14, 0.12), Vector3(0.72, 0, 0), steel_painted)
	return root


func _build_equipement_mural() -> Node3D:
	var root := _root("NP_Z03_COM_02_EquipementMural")
	_box(root, "Corps", Vector3(0.60, 0.80, 0.20), Vector3(0, 0.40, 0), steel_painted)
	_box(root, "Panneau", Vector3(0.38, 0.44, 0.03), Vector3(0, 0.47, -0.115), clinical)
	_box(root, "Indicateur", Vector3(0.08, 0.10, 0.02), Vector3(0.14, 0.64, -0.14), cyan)
	return root


func _export_asset(file_name: String, node: Node3D, output_path: String) -> bool:
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_scene(node, state) != OK:
		node.queue_free()
		_fail("Export GLB impossible : %s" % file_name)
		return false
	var output_file := output_path.path_join("%s.glb" % file_name)
	var write_error := document.write_to_filesystem(state, output_file)
	node.queue_free()
	if write_error != OK:
		_fail("Écriture GLB impossible : %s" % output_file)
		return false
	return true


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
