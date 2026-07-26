extends SceneTree

const MATERIALS := [
	{"path": "res://materiaux/m_concrete_sealed_light.tres", "name": "M_Concrete_Sealed_Light", "color": Color("#4a5561"), "metallic": 0.0, "roughness": 0.94},
	{"path": "res://materiaux/m_concrete_sealed_dark.tres", "name": "M_Concrete_Sealed_Dark", "color": Color("#1b232c"), "metallic": 0.0, "roughness": 0.92},
	{"path": "res://materiaux/m_steel_painted.tres", "name": "M_Steel_Painted", "color": Color("#7d8992"), "metallic": 0.26, "roughness": 0.64},
	{"path": "res://materiaux/m_steel_raw.tres", "name": "M_Steel_Raw", "color": Color("#3e4b54"), "metallic": 0.58, "roughness": 0.58},
	{"path": "res://materiaux/m_composite_medical.tres", "name": "M_Composite_Medical", "color": Color("#d7e0e2"), "metallic": 0.0, "roughness": 0.78},
	{"path": "res://materiaux/m_glass_reinforced.tres", "name": "M_Glass_Reinforced", "color": Color(0.384314, 0.505882, 0.556863, 0.22), "metallic": 0.0, "roughness": 0.18},
	{"path": "res://materiaux/m_accent_cyan.tres", "name": "M_Accent_Cyan", "color": Color("#40d5db"), "metallic": 0.05, "roughness": 0.58, "emissive": true},
	{"path": "res://materiaux/m_accent_amber.tres", "name": "M_Accent_Amber", "color": Color("#f0a43a"), "metallic": 0.05, "roughness": 0.55, "emissive": true},
	{"path": "res://materiaux/m_accent_danger.tres", "name": "M_Accent_Danger", "color": Color("#d94b4b"), "metallic": 0.05, "roughness": 0.55, "emissive": true}
]


func _init() -> void:
	var failures: Array[String] = []
	for expected: Dictionary in MATERIALS:
		_validate_material(expected, failures)
	_validate_signage(failures)
	if failures.is_empty():
		print("PHASE2_TECHNICAL_VALIDATION_PASS materials=%d signage=1" % MATERIALS.size())
		quit(0)
		return
	for failure: String in failures:
		push_error(failure)
	print("PHASE2_TECHNICAL_VALIDATION_FAIL count=%d" % failures.size())
	quit(1)


func _validate_material(expected: Dictionary, failures: Array[String]) -> void:
	var resource := load(expected.path)
	if not resource is StandardMaterial3D:
		failures.append("Ressource invalide : %s" % expected.path)
		return
	var material := resource as StandardMaterial3D
	if material.resource_name != expected.name:
		failures.append("Nom invalide : %s" % expected.path)
	if not material.albedo_color.is_equal_approx(expected.color):
		failures.append("Couleur invalide : %s" % expected.path)
	if not is_equal_approx(material.metallic, expected.metallic):
		failures.append("Métallique invalide : %s" % expected.path)
	if not is_equal_approx(material.roughness, expected.roughness):
		failures.append("Rugosité invalide : %s" % expected.path)
	if expected.get("emissive", false) and not material.emission_enabled:
		failures.append("Émission absente : %s" % expected.path)
	if expected.name == "M_Glass_Reinforced" and material.transparency != BaseMaterial3D.TRANSPARENCY_ALPHA:
		failures.append("Transparence invalide : %s" % expected.path)


func _validate_signage(failures: Array[String]) -> void:
	var file := FileAccess.open("res://signaletique/planche_signalisation_v1.svg", FileAccess.READ)
	if file == null:
		failures.append("Planche signalétique absente")
		return
	var content := file.get_as_text()
	for expected: String in ["ACCUEIL", "CONFINEMENT", "MÉDICAL", "SYNTHÈSE", "EXTRACTION", "FERMÉ", "ACHETABLE", "REFUSÉ", "ACHETÉ", "OUVERT"]:
		if expected not in content:
			failures.append("Signalétique incomplète : %s" % expected)
