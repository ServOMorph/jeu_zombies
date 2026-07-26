extends SceneTree

const EXPORTS := [
	{"id": "pistolet", "name": "NP_Z05_WPN_01_Pistolet", "length": 0.46, "height": 0.16, "width": 0.09, "magazine": 0.14, "stock": false, "heavy": false},
	{"id": "mitraillette", "name": "NP_Z05_WPN_02_Mitraillette", "length": 0.71, "height": 0.18, "width": 0.11, "magazine": 0.25, "stock": true, "heavy": false},
	{"id": "pompe", "name": "NP_Z05_WPN_03_FusilPompe", "length": 0.92, "height": 0.19, "width": 0.12, "magazine": 0.0, "stock": true, "heavy": false},
	{"id": "assaut", "name": "NP_Z05_WPN_04_FusilAssaut", "length": 1.02, "height": 0.20, "width": 0.12, "magazine": 0.28, "stock": true, "heavy": false},
	{"id": "precision", "name": "NP_Z05_WPN_05_FusilPrecision", "length": 1.28, "height": 0.16, "width": 0.09, "magazine": 0.10, "stock": true, "heavy": false},
	{"id": "lourde", "name": "NP_Z05_WPN_06_ArmeLourde", "length": 1.10, "height": 0.27, "width": 0.18, "magazine": 0.34, "stock": true, "heavy": true},
	{"id": "couteau", "name": "NP_Z05_WPN_07_Couteau", "length": 0.34, "height": 0.05, "width": 0.035, "magazine": 0.0, "stock": false, "heavy": false}
]

var material_dark: StandardMaterial3D
var material_light: StandardMaterial3D
var material_cyan: StandardMaterial3D
var material_amber: StandardMaterial3D
var material_grip: StandardMaterial3D


func _init() -> void:
	_create_materials()
	var output_path := ProjectSettings.globalize_path("res://exports")
	if DirAccess.make_dir_recursive_absolute(output_path) != OK:
		_fail("Création du dossier d'export impossible")
		return
	for data: Dictionary in EXPORTS:
		_export_weapon(data, false, output_path)
		_export_weapon(data, true, output_path)
	_export_arms(output_path)
	_export_wall_mount(output_path)
	_export_floor_silhouette(output_path)
	print("NOX_PROTOCOL_PHASE5_GLB_EXPORT_READY weapons=14 supports=2 arms=1")
	quit(0)


func _create_materials() -> void:
	material_dark = _material(Color("#1b232b"), 0.78, 0.20)
	material_light = _material(Color("#aab4b8"), 0.68, 0.38)
	material_cyan = _material(Color("#40d5db"), 0.50, 0.15, Color("#0a3439"))
	material_amber = _material(Color("#f0a43a"), 0.55, 0.12, Color("#3b2108"))
	material_grip = _material(Color("#111820"), 0.92, 0.0)


func _material(color: Color, roughness: float, metallic: float, emission: Color = Color.BLACK) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	if emission != Color.BLACK:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = 0.55
	return material


func _export_weapon(data: Dictionary, improved: bool, output_path: String) -> void:
	var weapon := _build_weapon(data, improved)
	var suffix := "_ameliore" if improved else ""
	_write_glb(weapon, output_path.path_join("np_z05_%s%s.glb" % [data.id, suffix]))
	weapon.queue_free()


func _build_weapon(data: Dictionary, improved: bool) -> Node3D:
	var root := Node3D.new()
	root.name = "%s%s" % [data.name, "_Ameliore" if improved else ""]
	var visual_root := Node3D.new()
	visual_root.name = "WeaponVisualRoot"
	root.add_child(visual_root)
	var length: float = data.length
	if data.id == "couteau":
		_build_knife(visual_root, improved)
	else:
		_add_box(visual_root, "Corps", Vector3(data.width, data.height, length * 0.44), Vector3(0.0, 0.0, -length * 0.06), material_dark)
		_add_box(visual_root, "Culasse", Vector3(data.width * 1.06, data.height * 0.52, length * 0.27), Vector3(0.0, data.height * 0.22, length * 0.17), material_light)
		_add_cylinder(visual_root, "Canon", data.width * 0.27, length * (0.48 if data.id != "pompe" else 0.58), Vector3(0.0, 0.0, -length * 0.47), material_grip)
		_add_box(visual_root, "Poignee", Vector3(data.width * 0.75, data.height * 1.25, data.width * 1.25), Vector3(0.0, -data.height * 0.68, length * 0.05), material_grip, Vector3(deg_to_rad(-12.0), 0.0, 0.0))
		if data.magazine > 0.0:
			_add_box(visual_root, "Chargeur", Vector3(data.width * 0.78, data.magazine, data.width * 1.10), Vector3(0.0, -data.magazine * 0.55, -length * 0.05), material_dark, Vector3(deg_to_rad(-8.0), 0.0, 0.0))
		if data.stock:
			_add_box(visual_root, "Crosse", Vector3(data.width * 0.95, data.height * 0.72, length * 0.25), Vector3(0.0, 0.0, length * 0.36), material_grip)
		if data.id == "pompe":
			_add_box(visual_root, "Pompe", Vector3(data.width * 1.18, data.height * 0.62, length * 0.30), Vector3(0.0, -data.height * 0.38, -length * 0.28), material_grip)
		if data.id == "precision":
			_add_cylinder(visual_root, "Lunette", data.width * 0.34, length * 0.21, Vector3(0.0, data.height * 0.52, -length * 0.04), material_grip)
		if data.heavy:
			_add_box(visual_root, "Tambour", Vector3(data.width * 1.35, data.magazine, data.width * 1.55), Vector3(0.0, -data.magazine * 0.30, -length * 0.12), material_dark)
			_add_box(visual_root, "PoigneeAvant", Vector3(data.width * 0.65, data.height * 1.45, data.width), Vector3(0.0, -data.height * 0.62, -length * 0.28), material_grip)
		_add_box(visual_root, "AccentFonctionnel", Vector3(data.width * 0.34, data.height * 0.12, length * 0.12), Vector3(0.0, data.height * 0.38, -length * 0.16), material_cyan if improved else material_amber)
		if improved:
			_add_box(visual_root, "ModuleAmeliore", Vector3(data.width * 1.10, data.height * 0.20, length * 0.20), Vector3(0.0, data.height * 0.47, length * 0.12), material_cyan)
	var muzzle := Node3D.new()
	muzzle.name = "MuzzleFlash"
	muzzle.position = Vector3(0.0, 0.0, -length * 0.62)
	visual_root.add_child(muzzle)
	_add_animation_player(root)
	return root


func _build_knife(parent: Node3D, improved: bool) -> void:
	_add_box(parent, "Lame", Vector3(0.035, 0.05, 0.26), Vector3(0.0, 0.0, -0.08), material_light)
	_add_box(parent, "Garde", Vector3(0.14, 0.05, 0.035), Vector3(0.0, 0.0, 0.06), material_dark)
	_add_box(parent, "Manche", Vector3(0.065, 0.07, 0.15), Vector3(0.0, 0.0, 0.15), material_grip)
	_add_box(parent, "AccentFonctionnel", Vector3(0.025, 0.018, 0.06), Vector3(0.0, 0.04, 0.14), material_cyan if improved else material_amber)
	if improved:
		_add_box(parent, "DorsaleRenforcee", Vector3(0.045, 0.025, 0.22), Vector3(0.0, 0.038, -0.08), material_cyan)


func _export_arms(output_path: String) -> void:
	var root := Node3D.new()
	root.name = "NP_Z05_FPS_BrasScientifique"
	for side: float in [-1.0, 1.0]:
		var arm := Node3D.new()
		arm.name = "Bras_G" if side < 0.0 else "Bras_D"
		arm.position = Vector3(side * 0.18, -0.18, 0.18)
		arm.rotation = Vector3(deg_to_rad(-24.0), deg_to_rad(side * 11.0), deg_to_rad(side * 10.0))
		root.add_child(arm)
		_add_box(arm, "AvantBras", Vector3(0.12, 0.12, 0.46), Vector3(0.0, 0.0, -0.12), material_light)
		_add_box(arm, "Gant", Vector3(0.14, 0.11, 0.18), Vector3(0.0, -0.01, -0.42), material_grip)
		_add_box(arm, "Poignet", Vector3(0.15, 0.13, 0.07), Vector3(0.0, 0.0, -0.29), material_cyan)
	_write_glb(root, output_path.path_join("np_z05_bras_scientifique.glb"))
	root.queue_free()


func _export_wall_mount(output_path: String) -> void:
	var root := Node3D.new()
	root.name = "NP_Z05_PresentationMurale"
	_add_box(root, "Panneau", Vector3(1.20, 0.72, 0.06), Vector3.ZERO, material_dark)
	_add_box(root, "Contour", Vector3(1.28, 0.06, 0.09), Vector3(0.0, 0.38, -0.02), material_light)
	_add_box(root, "Support", Vector3(0.62, 0.10, 0.16), Vector3(0.0, -0.10, -0.10), material_grip)
	_add_box(root, "EtatDisponible", Vector3(0.22, 0.05, 0.08), Vector3(0.0, -0.29, -0.06), material_amber)
	_write_glb(root, output_path.path_join("np_z05_presentation_murale.glb"))
	root.queue_free()


func _export_floor_silhouette(output_path: String) -> void:
	var root := Node3D.new()
	root.name = "NP_Z05_SilhouetteSol"
	_add_box(root, "PlaqueSol", Vector3(1.10, 0.012, 0.44), Vector3.ZERO, material_dark)
	_add_box(root, "Silhouette", Vector3(0.72, 0.014, 0.12), Vector3(0.0, 0.014, 0.0), material_amber)
	_add_box(root, "RepereTete", Vector3(0.10, 0.014, 0.20), Vector3(0.31, 0.014, 0.0), material_amber)
	_write_glb(root, output_path.path_join("np_z05_silhouette_sol.glb"))
	root.queue_free()


func _add_animation_player(root: Node3D) -> void:
	var player := AnimationPlayer.new()
	player.name = "AnimationPlayer"
	root.add_child(player)
	var library := AnimationLibrary.new()
	library.add_animation("equip", _make_animation(0.42, Vector3(0.0, -0.14, 0.16), Vector3.ZERO))
	library.add_animation("tir", _make_animation(0.12, Vector3(0.0, 0.0, 0.055), Vector3.ZERO))
	library.add_animation("recul", _make_animation(0.16, Vector3(0.0, 0.0, 0.085), Vector3.ZERO))
	library.add_animation("rechargement", _make_animation(1.15, Vector3(0.0, -0.08, 0.04), Vector3(0.0, 0.14, 0.0)))
	library.add_animation("melee", _make_animation(0.46, Vector3(0.0, 0.02, 0.10), Vector3(deg_to_rad(-28.0), 0.0, 0.0)))
	player.add_animation_library("", library)


func _make_animation(length: float, midpoint_position: Vector3, midpoint_rotation: Vector3) -> Animation:
	var animation := Animation.new()
	animation.length = length
	var position_track := animation.add_track(Animation.TYPE_POSITION_3D)
	animation.track_set_path(position_track, NodePath("WeaponVisualRoot"))
	animation.track_insert_key(position_track, 0.0, Vector3.ZERO)
	animation.track_insert_key(position_track, length * 0.5, midpoint_position)
	animation.track_insert_key(position_track, length, Vector3.ZERO)
	var rotation_track := animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(rotation_track, NodePath("WeaponVisualRoot"))
	animation.track_insert_key(rotation_track, 0.0, Quaternion.IDENTITY)
	animation.track_insert_key(rotation_track, length * 0.5, Quaternion.from_euler(midpoint_rotation))
	animation.track_insert_key(rotation_track, length, Quaternion.IDENTITY)
	return animation


func _add_box(parent: Node3D, node_name: String, size: Vector3, position: Vector3, material: Material, rotation: Vector3 = Vector3.ZERO) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = material
	instance.mesh = mesh
	instance.position = position
	instance.rotation = rotation
	parent.add_child(instance)


func _add_cylinder(parent: Node3D, node_name: String, radius: float, depth: float, position: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = depth
	mesh.radial_segments = 8
	mesh.rings = 1
	mesh.material = material
	instance.mesh = mesh
	instance.position = position
	instance.rotation = Vector3(deg_to_rad(90.0), 0.0, 0.0)
	parent.add_child(instance)


func _write_glb(root: Node3D, path: String) -> void:
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_scene(root, state) != OK:
		root.queue_free()
		_fail("Conversion GLTF impossible : %s" % root.name)
		return
	if document.write_to_filesystem(state, path) != OK:
		root.queue_free()
		_fail("Écriture GLB impossible : %s" % path)
	root.queue_free()


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
