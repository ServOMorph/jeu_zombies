extends SceneTree

const PHASE1_PATH := "res://assets/phase1"
const PHASE2_PATH := "res://assets/phase2"
const PHASE4_PATH := "res://assets/phase4/np_z04_zombie_standard.glb"
const PHASE5_PATH := "res://assets/phase5"
const REQUIRED_ANIMATIONS := ["equip", "tir", "recul", "rechargement", "melee"]
const NON_WEAPON_EXPORTS := ["np_z05_bras_scientifique.glb", "np_z05_presentation_murale.glb", "np_z05_silhouette_sol.glb"]
const MATERIALS := [
	{"file": "m_concrete_sealed_light.tres", "name": "M_Concrete_Sealed_Light", "color": Color("#4a5561"), "metallic": 0.0, "roughness": 0.94},
	{"file": "m_concrete_sealed_dark.tres", "name": "M_Concrete_Sealed_Dark", "color": Color("#1b232c"), "metallic": 0.0, "roughness": 0.92},
	{"file": "m_steel_painted.tres", "name": "M_Steel_Painted", "color": Color("#7d8992"), "metallic": 0.26, "roughness": 0.64},
	{"file": "m_steel_raw.tres", "name": "M_Steel_Raw", "color": Color("#3e4b54"), "metallic": 0.58, "roughness": 0.58},
	{"file": "m_composite_medical.tres", "name": "M_Composite_Medical", "color": Color("#d7e0e2"), "metallic": 0.0, "roughness": 0.78},
	{"file": "m_glass_reinforced.tres", "name": "M_Glass_Reinforced", "color": Color(0.384314, 0.505882, 0.556863, 0.22), "metallic": 0.0, "roughness": 0.18, "transparent": true},
	{"file": "m_accent_cyan.tres", "name": "M_Accent_Cyan", "color": Color("#40d5db"), "metallic": 0.05, "roughness": 0.58, "emissive": true},
	{"file": "m_accent_amber.tres", "name": "M_Accent_Amber", "color": Color("#f0a43a"), "metallic": 0.05, "roughness": 0.55, "emissive": true},
	{"file": "m_accent_danger.tres", "name": "M_Accent_Danger", "color": Color("#d94b4b"), "metallic": 0.05, "roughness": 0.55, "emissive": true},
]


func _init() -> void:
	var findings: Array[Dictionary] = []
	_validate_phase1(findings)
	_validate_phase2(findings)
	_validate_phase4(findings)
	_validate_phase5(findings)
	var passed := 0
	var failed := 0
	for finding: Dictionary in findings:
		if finding["status"] == "passed":
			passed += 1
		else:
			failed += 1
	var result := {"schema_version": 1, "findings": findings, "passed": passed, "failed": failed}
	var handle := FileAccess.open("res://qualification_results.json", FileAccess.WRITE)
	if handle == null:
		push_error("Impossible d'écrire les résultats de qualification")
		quit(1)
		return
	handle.store_string(JSON.stringify(result, "\t") + "\n")
	handle.close()
	print("NOX_PROTOCOL_DI3_QUALIFICATION completed passed=%d failed=%d" % [passed, failed])
	quit(0)


func _validate_phase1(findings: Array[Dictionary]) -> void:
	var files := _glb_files(PHASE1_PATH)
	if files.size() != 23:
		_find(findings, "phase1", "lot", "failed", "Nombre d'exports inattendu: %d" % files.size())
		return
	for file: String in files:
		var scene := _load_glb("%s/%s" % [PHASE1_PATH, file], findings, "phase1", file)
		if scene == null:
			continue
		if _count_meshes(scene) < 1:
			_find(findings, "phase1", file, "failed", "Aucun mesh")
		elif not scene.position.is_zero_approx() or not scene.basis.is_equal_approx(Basis.IDENTITY):
			_find(findings, "phase1", file, "failed", "Pivot ou axes racine non neutres")
		else:
			_find(findings, "phase1", file, "passed", "GLB lisible, mesh et racine neutre")
		scene.free()


func _validate_phase2(findings: Array[Dictionary]) -> void:
	for expected: Dictionary in MATERIALS:
		var resource := load("%s/%s" % [PHASE2_PATH, expected["file"]])
		if not resource is StandardMaterial3D:
			_find(findings, "phase2", expected["file"], "failed", "Ressource non StandardMaterial3D")
			continue
		var material := resource as StandardMaterial3D
		var valid: bool = material.resource_name == expected["name"] and material.albedo_color.is_equal_approx(expected["color"]) and is_equal_approx(material.metallic, expected["metallic"]) and is_equal_approx(material.roughness, expected["roughness"])
		valid = valid and (not expected.get("emissive", false) or material.emission_enabled)
		valid = valid and (not expected.get("transparent", false) or material.transparency == BaseMaterial3D.TRANSPARENCY_ALPHA)
		_find(findings, "phase2", expected["file"], "passed" if valid else "failed", "Matériau conforme" if valid else "Propriétés de matériau non conformes")
	var signage := FileAccess.open("%s/planche_signalisation_v1.svg" % PHASE2_PATH, FileAccess.READ)
	if signage == null:
		_find(findings, "phase2", "planche_signalisation_v1.svg", "failed", "Planche absente")
		return
	var content := signage.get_as_text()
	signage.close()
	var valid_signage: bool = true
	for label: String in ["ACCUEIL", "CONFINEMENT", "MÉDICAL", "SYNTHÈSE", "EXTRACTION", "FERMÉ", "ACHETABLE", "REFUSÉ", "ACHETÉ", "OUVERT"]:
		valid_signage = valid_signage and label in content
	_find(findings, "phase2", "planche_signalisation_v1.svg", "passed" if valid_signage else "failed", "Signalétique complète" if valid_signage else "Signalétique incomplète")


func _validate_phase4(findings: Array[Dictionary]) -> void:
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_file(ProjectSettings.globalize_path(PHASE4_PATH), state) != OK:
		_find(findings, "phase4", "np_z04_zombie_standard.glb", "failed", "GLB illisible")
		return
	var scene := document.generate_scene(state)
	if scene == null or scene.name != "NP_Z04_ZOM_01_Standard" or _count_meshes(scene) < 15 or state.get_animations().size() != 8 or state.get_skins().size() != 1:
		_find(findings, "phase4", "np_z04_zombie_standard.glb", "failed", "Structure, meshes, animations ou skin invalides")
	else:
		_find(findings, "phase4", "np_z04_zombie_standard.glb", "passed", "GLB, meshes, animations et skin conformes")
	if state.get_materials().size() > 4:
		_find(findings, "phase4", "np_z04_zombie_standard.glb", "failed", "Budget matériaux dépassé: %d/4" % state.get_materials().size())
	if scene != null:
		scene.free()


func _validate_phase5(findings: Array[Dictionary]) -> void:
	var files := _glb_files(PHASE5_PATH)
	if files.size() != 17:
		_find(findings, "phase5", "lot", "failed", "Nombre d'exports inattendu: %d" % files.size())
		return
	for file: String in files:
		var document := GLTFDocument.new()
		var state := GLTFState.new()
		if document.append_from_file(ProjectSettings.globalize_path("%s/%s" % [PHASE5_PATH, file]), state) != OK:
			_find(findings, "phase5", file, "failed", "GLB illisible")
			continue
		var scene := document.generate_scene(state)
		if scene == null or _count_meshes(scene) < 2:
			_find(findings, "phase5", file, "failed", "Scène incomplète")
		elif not file in NON_WEAPON_EXPORTS and (scene.find_child("WeaponVisualRoot", true, false) == null or scene.find_child("MuzzleFlash", true, false) == null or state.get_animations().size() != REQUIRED_ANIMATIONS.size()):
			_find(findings, "phase5", file, "failed", "Ancrages FPS ou animations absents")
		else:
			_find(findings, "phase5", file, "passed", "GLB et contrat technique isolé conformes")
		if scene != null:
			scene.free()


func _load_glb(path: String, findings: Array[Dictionary], lot: String, asset: String) -> Node3D:
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_file(ProjectSettings.globalize_path(path), state) != OK:
		_find(findings, lot, asset, "failed", "GLB illisible")
		return null
	var scene := document.generate_scene(state) as Node3D
	if scene == null:
		_find(findings, lot, asset, "failed", "Scène GLB non générée")
	return scene


func _glb_files(path: String) -> Array[String]:
	var directory := DirAccess.open(path)
	var files: Array[String] = []
	if directory == null:
		return files
	directory.list_dir_begin()
	var file := directory.get_next()
	while file != "":
		if not directory.current_is_dir() and file.get_extension().to_lower() == "glb":
			files.append(file)
		file = directory.get_next()
	directory.list_dir_end()
	files.sort()
	return files


func _count_meshes(node: Node) -> int:
	var count := 1 if node is MeshInstance3D else 0
	for child: Node in node.get_children():
		count += _count_meshes(child)
	return count


func _find(findings: Array[Dictionary], lot: String, asset: String, status: String, detail: String) -> void:
	findings.append({"lot": lot, "asset": asset, "status": status, "detail": detail})
