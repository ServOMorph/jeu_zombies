extends SceneTree

const EXPORTS := [
	{"id": "support_arme", "label": "SUPPORT ARME", "builder": "_build_weapon_mount"},
	{"id": "repere_munitions", "label": "MUNITIONS", "builder": "_build_ammo_marker"},
	{"id": "caisse_aleatoire", "label": "ARMEMENT", "builder": "_build_random_crate"},
	{"id": "station_amelioration", "label": "AMELIORATION", "builder": "_build_upgrade_station"},
	{"id": "avantage_constitution", "label": "CONSTITUTION", "builder": "_build_perk_station", "accent": "green"},
	{"id": "avantage_gestes", "label": "GESTES PRECIS", "builder": "_build_perk_station", "accent": "amber"},
	{"id": "avantage_reflexes", "label": "REFLEXES", "builder": "_build_perk_station", "accent": "cyan"},
	{"id": "avantage_reparation", "label": "REPARATION", "builder": "_build_perk_station", "accent": "violet"},
	{"id": "composant_neural", "label": "NOYAU NEURAL", "builder": "_build_component", "accent": "cyan"},
	{"id": "composant_serum", "label": "SERUM", "builder": "_build_component", "accent": "green"},
	{"id": "composant_relais", "label": "RELAIS", "builder": "_build_component", "accent": "amber"},
	{"id": "antidote", "label": "ANTIDOTE", "builder": "_build_antidote"},
	{"id": "synthetiseur", "label": "SYNTHESE", "builder": "_build_synthesizer"},
	{"id": "point_deploiement", "label": "DEPLOIEMENT", "builder": "_build_deployment"},
	{"id": "terminal_extraction", "label": "EXTRACTION", "builder": "_build_terminal"},
	{"id": "balise_finale", "label": "DEFENSE", "builder": "_build_final_beacon"}
]

var dark: StandardMaterial3D
var steel: StandardMaterial3D
var clinical: StandardMaterial3D
var cyan: StandardMaterial3D
var amber: StandardMaterial3D
var red: StandardMaterial3D
var green: StandardMaterial3D
var violet: StandardMaterial3D


func _init() -> void:
	_create_materials()
	var output_path := ProjectSettings.globalize_path("res://exports")
	if DirAccess.make_dir_recursive_absolute(output_path) != OK:
		_fail("Création du dossier d'export impossible")
		return
	for data: Dictionary in EXPORTS:
		var asset: Node3D = call(data.builder, data)
		if asset == null:
			_fail("Production impossible : %s" % data.id)
			return
		_write_glb(asset, output_path.path_join("np_z06_%s.glb" % data.id))
		asset.queue_free()
	print("NOX_PROTOCOL_PHASE6_GLB_EXPORT_READY assets=%d" % EXPORTS.size())
	quit(0)


func _create_materials() -> void:
	dark = _material(Color("#111820"), 0.78, 0.26)
	steel = _material(Color("#87949c"), 0.60, 0.42)
	clinical = _material(Color("#d9e2e1"), 0.72, 0.10)
	cyan = _material(Color("#40d5db"), 0.46, 0.12, Color("#0c4a50"))
	amber = _material(Color("#f0a43a"), 0.50, 0.12, Color("#4a2608"))
	red = _material(Color("#d94b4b"), 0.52, 0.08, Color("#4a1114"))
	green = _material(Color("#71c982"), 0.52, 0.08, Color("#164223"))
	violet = _material(Color("#a477d8"), 0.52, 0.08, Color("#2e1745"))


func _material(color: Color, roughness: float, metallic: float, emission: Color = Color.BLACK) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	if emission != Color.BLACK:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = 0.7
	return material


func _root(data: Dictionary) -> Node3D:
	var root := Node3D.new()
	root.name = "NP_Z06_%s" % data.id.capitalize()
	var point := Node3D.new()
	point.name = "InteractionAnchor"
	point.position = Vector3(0.0, 1.0, 0.42)
	root.add_child(point)
	_add_state_markers(root)
	return root


func _accent(data: Dictionary) -> Material:
	match data.get("accent", "cyan"):
		"amber": return amber
		"green": return green
		"violet": return violet
		_: return cyan


func _build_weapon_mount(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_box(root, "Panneau", Vector3(1.35, 0.90, 0.08), Vector3(0.0, 1.20, 0.0), dark)
	_add_box(root, "Cadre", Vector3(1.48, 0.08, 0.13), Vector3(0.0, 1.68, -0.03), steel)
	_add_box(root, "Berceau", Vector3(0.70, 0.11, 0.20), Vector3(0.0, 1.10, -0.14), steel)
	_add_box(root, "MarquePrix", Vector3(0.28, 0.12, 0.05), Vector3(0.45, 0.78, -0.07), amber)
	_add_label(root, "ARME", Vector3(0.0, 1.43, -0.07), 42)
	return root


func _build_ammo_marker(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_box(root, "PlaqueMurale", Vector3(0.78, 0.82, 0.07), Vector3.ZERO + Vector3(0.0, 1.10, 0.0), dark)
	_add_cylinder(root, "Cartouche1", 0.06, 0.40, Vector3(-0.12, 1.10, -0.10), amber)
	_add_cylinder(root, "Cartouche2", 0.06, 0.40, Vector3(0.05, 1.10, -0.10), amber)
	_add_cylinder(root, "Cartouche3", 0.06, 0.40, Vector3(0.22, 1.10, -0.10), amber)
	_add_label(root, "MUNITIONS", Vector3(0.0, 0.62, -0.06), 28)
	return root


func _build_random_crate(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_box(root, "Caisson", Vector3(1.40, 0.90, 0.95), Vector3(0.0, 0.55, 0.0), dark)
	_add_box(root, "Capot", Vector3(1.48, 0.14, 1.02), Vector3(0.0, 1.08, 0.0), steel)
	for x: float in [-0.55, 0.55]:
		_add_box(root, "Renfort", Vector3(0.10, 1.00, 1.02), Vector3(x, 0.55, 0.0), steel)
	_add_box(root, "Voyant", Vector3(0.38, 0.08, 0.05), Vector3(0.0, 0.73, -0.51), amber)
	_add_label(root, "ARMEMENT", Vector3(0.0, 0.48, -0.52), 32)
	return root


func _build_upgrade_station(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_cylinder(root, "Socle", 0.55, 0.22, Vector3(0.0, 0.11, 0.0), dark)
	_add_cylinder(root, "Colonne", 0.23, 1.15, Vector3(0.0, 0.70, 0.0), steel)
	_add_cylinder(root, "Anneau", 0.40, 0.12, Vector3(0.0, 1.18, 0.0), cyan)
	_add_box(root, "Plateau", Vector3(0.92, 0.12, 0.72), Vector3(0.0, 1.34, 0.0), clinical)
	_add_label(root, "AMELIORATION", Vector3(0.0, 1.58, -0.02), 26)
	return root


func _build_perk_station(data: Dictionary) -> Node3D:
	var root := _root(data)
	var accent := _accent(data)
	_add_cylinder(root, "Socle", 0.42, 0.16, Vector3(0.0, 0.08, 0.0), dark)
	_add_cylinder(root, "Chassis", 0.18, 1.22, Vector3(0.0, 0.70, 0.0), steel)
	_add_box(root, "Pictogramme", Vector3(0.48, 0.48, 0.08), Vector3(0.0, 1.18, -0.13), accent)
	_add_box(root, "BandeEtat", Vector3(0.36, 0.06, 0.10), Vector3(0.0, 0.58, -0.18), accent)
	_add_label(root, data.label, Vector3(0.0, 1.55, -0.15), 22)
	return root


func _build_component(data: Dictionary) -> Node3D:
	var root := _root(data)
	var accent := _accent(data)
	_add_box(root, "Boitier", Vector3(0.44, 0.28, 0.26), Vector3(0.0, 0.30, 0.0), dark)
	_add_box(root, "Noyau", Vector3(0.22, 0.16, 0.12), Vector3(0.0, 0.30, -0.16), accent)
	_add_box(root, "Poignee", Vector3(0.10, 0.12, 0.34), Vector3(0.0, 0.52, 0.0), steel)
	_add_label(root, data.label, Vector3(0.0, 0.05, -0.15), 18)
	return root


func _build_antidote(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_cylinder(root, "Contenant", 0.16, 0.64, Vector3(0.0, 0.36, 0.0), clinical)
	_add_cylinder(root, "Serum", 0.12, 0.42, Vector3(0.0, 0.32, 0.0), green)
	_add_cylinder(root, "Bouchon", 0.18, 0.10, Vector3(0.0, 0.73, 0.0), dark)
	_add_box(root, "Poignee", Vector3(0.34, 0.07, 0.12), Vector3(0.0, 0.82, 0.0), steel)
	_add_label(root, "ANTIDOTE", Vector3(0.0, 0.08, -0.16), 22)
	return root


func _build_synthesizer(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_box(root, "Corps", Vector3(1.50, 1.35, 0.82), Vector3(0.0, 0.68, 0.0), dark)
	_add_cylinder(root, "Cuve", 0.32, 0.72, Vector3(0.0, 1.48, 0.0), clinical)
	_add_cylinder(root, "CuveInterne", 0.24, 0.62, Vector3(0.0, 1.48, 0.0), green)
	_add_box(root, "Console", Vector3(0.58, 0.34, 0.10), Vector3(0.0, 1.05, -0.48), cyan)
	_add_label(root, "SYNTHESE", Vector3(0.0, 0.70, -0.43), 28)
	return root


func _build_deployment(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_cylinder(root, "AnneauSol", 0.78, 0.08, Vector3(0.0, 0.04, 0.0), cyan)
	_add_cylinder(root, "Noyau", 0.22, 0.28, Vector3(0.0, 0.18, 0.0), dark)
	for angle: float in [0.0, 120.0, 240.0]:
		var position := Vector3(0.50, 0.30, 0.0).rotated(Vector3.UP, deg_to_rad(angle))
		_add_box(root, "Guide", Vector3(0.24, 0.56, 0.12), position, steel)
	_add_label(root, "DEPLOIEMENT", Vector3(0.0, 0.78, 0.0), 24)
	return root


func _build_terminal(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_box(root, "Pied", Vector3(0.46, 1.35, 0.46), Vector3(0.0, 0.68, 0.0), dark)
	_add_box(root, "Ecran", Vector3(0.80, 0.54, 0.10), Vector3(0.0, 1.42, -0.15), cyan)
	_add_box(root, "Clavier", Vector3(0.62, 0.08, 0.38), Vector3(0.0, 1.10, -0.28), steel)
	_add_box(root, "Antenne", Vector3(0.08, 0.54, 0.08), Vector3(0.0, 1.92, 0.0), amber)
	_add_label(root, "EXTRACTION", Vector3(0.0, 1.43, -0.22), 25)
	return root


func _build_final_beacon(data: Dictionary) -> Node3D:
	var root := _root(data)
	_add_cylinder(root, "Socle", 0.36, 0.14, Vector3(0.0, 0.07, 0.0), dark)
	_add_cylinder(root, "Mat", 0.08, 2.25, Vector3(0.0, 1.20, 0.0), steel)
	_add_box(root, "Signal", Vector3(0.34, 0.34, 0.34), Vector3(0.0, 2.35, 0.0), red)
	_add_box(root, "Panneau", Vector3(0.62, 0.34, 0.07), Vector3(0.0, 1.52, -0.10), amber)
	_add_label(root, "DEFENSE", Vector3(0.0, 1.52, -0.16), 24)
	return root


func _add_state_markers(root: Node3D) -> void:
	var states := Node3D.new()
	states.name = "StateMarkers"
	root.add_child(states)
	for state: String in ["Inactive", "Available", "Targeted", "Refused", "Active", "Completed"]:
		var marker := Node3D.new()
		marker.name = state
		states.add_child(marker)


func _add_box(parent: Node3D, node_name: String, size: Vector3, position: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = material
	instance.mesh = mesh
	instance.position = position
	parent.add_child(instance)


func _add_cylinder(parent: Node3D, node_name: String, radius: float, height: float, position: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 8
	mesh.rings = 1
	mesh.material = material
	instance.mesh = mesh
	instance.position = position
	parent.add_child(instance)


func _add_label(parent: Node3D, text_label: String, position: Vector3, font_size: int) -> void:
	var label := Label3D.new()
	label.name = "Label_%s" % text_label.replace(" ", "_")
	label.text = text_label
	label.position = position
	label.pixel_size = 0.005
	label.font_size = font_size
	label.outline_size = 4
	label.modulate = Color("#d9e2e1")
	label.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	label.rotation_degrees.y = 180.0
	label.scale.x = -1.0
	parent.add_child(label)


func _write_glb(root: Node3D, path: String) -> void:
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_scene(root, state) != OK:
		_fail("Conversion GLB impossible : %s" % root.name)
		return
	if document.write_to_filesystem(state, path) != OK:
		_fail("Écriture GLB impossible : %s" % path)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
