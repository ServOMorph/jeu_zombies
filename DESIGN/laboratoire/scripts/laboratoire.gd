extends Node3D

const IMPORTS_PATH := "res://imports"
const PHASE2_MATERIALS_PATH := "res://imports/phase2"
const PHASE3_ASSETS_PATH := "res://imports/phase3"
const PHASE3_ZONES_PATH := "res://imports/phase3/zones"
const PHASE4_ASSETS_PATH := "res://imports/phase4"
const PHASE5_ASSETS_PATH := "res://imports/phase5"
const PHASE6_ASSETS_PATH := "res://imports/phase6"
const ALLOWED_EXTENSIONS := ["glb", "gltf", "tscn"]
const CYAN := Color("#40d5db")
const AMBER := Color("#f0a43a")
const RED := Color("#d94b4b")

var _materials: Dictionary[String, StandardMaterial3D] = {}
var _phase2_materials: Dictionary[String, Material] = {}
var _world_environment: WorldEnvironment
var _accent_lights: Array[OmniLight3D] = []
var _asset_anchor: Node3D
var _placeholder: Node3D
var _preview_instance: Node3D
var _asset_paths: PackedStringArray = []
var _asset_index := -1
var _asset_scale := 1.0
var _architecture: Node3D
var _validation_root: Node3D
var _validation_vignettes: Array[Node3D] = []
var _validation_index := -1
var _player: CharacterBody3D
var _light_mode := 0
var _help_visible := true
var _help_background: ColorRect
var _help_label: Label
var _status_label: Label
var _selection_menu: PanelContainer


func _ready() -> void:
	_register_inputs()
	_create_materials()
	_create_environment()
	_create_architecture()
	_create_lighting()
	_create_player()
	_create_interface()
	_discover_assets()
	_create_validation_vignettes()
	_create_selection_menu()
	print("NOX_PROTOCOL_DESIGN_LAB_READY")
	print("NOX_PROTOCOL_VALIDATION_VIGNETTES_READY")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("lab_help"):
		_help_visible = not _help_visible
		_help_background.visible = _help_visible
		_help_label.visible = _help_visible
	if Input.is_action_just_pressed("lab_menu"):
		_set_selection_menu_visible(not _selection_menu.visible)
	if Input.is_action_just_pressed("lab_light"):
		_light_mode = (_light_mode + 1) % 3
		_apply_light_mode()
	if Input.is_action_just_pressed("lab_asset_previous"):
		_change_asset(-1)
	if Input.is_action_just_pressed("lab_asset_next"):
		_change_asset(1)
	if Input.is_action_just_pressed("lab_validation_next"):
		_change_validation_vignette()
	if Input.is_action_just_pressed("lab_scale_down"):
		_change_asset_scale(0.8)
	if Input.is_action_just_pressed("lab_scale_up"):
		_change_asset_scale(1.25)
	if Input.is_action_just_pressed("lab_rotate") and is_instance_valid(_preview_instance):
		_preview_instance.rotate_y(deg_to_rad(45.0))


func _register_inputs() -> void:
	_bind_keys("lab_move_forward", [KEY_W, KEY_Z, KEY_UP])
	_bind_keys("lab_move_backward", [KEY_S, KEY_DOWN])
	_bind_keys("lab_move_left", [KEY_A, KEY_Q, KEY_LEFT])
	_bind_keys("lab_move_right", [KEY_D, KEY_RIGHT])
	_bind_keys("lab_sprint", [KEY_SHIFT])
	_bind_keys("lab_cursor", [KEY_ESCAPE])
	_bind_keys("lab_help", [KEY_F1])
	_bind_keys("lab_menu", [KEY_F4])
	_bind_keys("lab_light", [KEY_F2])
	_bind_keys("lab_asset_previous", [KEY_PAGEUP])
	_bind_keys("lab_asset_next", [KEY_PAGEDOWN])
	_bind_keys("lab_validation_next", [KEY_F3])
	_bind_keys("lab_scale_down", [KEY_MINUS, KEY_KP_SUBTRACT])
	_bind_keys("lab_scale_up", [KEY_EQUAL, KEY_KP_ADD])
	_bind_keys("lab_rotate", [KEY_R])


func _bind_keys(action_name: StringName, keys: Array[Key]) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	for key: Key in keys:
		var event := InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event(action_name, event)


func _create_materials() -> void:
	_materials["concrete"] = _material(Color("#4a5561"), 0.94)
	_materials["concrete_dark"] = _material(Color("#1b232c"), 0.92)
	_materials["steel"] = _material(Color("#7d8992"), 0.64, 0.26)
	_materials["steel_dark"] = _material(Color("#111820"), 0.72, 0.32)
	_materials["clinical"] = _material(Color("#d7e0e2"), 0.78)
	_materials["cyan"] = _material(CYAN, 0.58, 0.05, CYAN * 0.18)
	_materials["amber"] = _material(AMBER, 0.55, 0.05, AMBER * 0.35)
	_materials["red"] = _material(RED, 0.55, 0.05, RED * 0.28)
	_load_phase2_materials()


func _load_phase2_materials() -> void:
	for material_data: Dictionary in [
		{"key": "concrete_light", "file": "m_concrete_sealed_light.tres"},
		{"key": "concrete_dark", "file": "m_concrete_sealed_dark.tres"},
		{"key": "steel_painted", "file": "m_steel_painted.tres"},
		{"key": "steel_raw", "file": "m_steel_raw.tres"},
		{"key": "clinical", "file": "m_composite_medical.tres"},
		{"key": "glass", "file": "m_glass_reinforced.tres"},
		{"key": "cyan", "file": "m_accent_cyan.tres"},
		{"key": "amber", "file": "m_accent_amber.tres"},
		{"key": "danger", "file": "m_accent_danger.tres"}
	]:
		var path := "%s/%s" % [PHASE2_MATERIALS_PATH, material_data.file]
		var material := load(path) as Material
		if material == null:
			push_error("Matériau phase 2 introuvable : %s" % path)
			continue
		_phase2_materials[material_data.key] = material


func _phase2_material(key: String) -> Material:
	return _phase2_materials[key]


func _material(
	color: Color,
	roughness: float,
	metallic: float = 0.0,
	emission: Color = Color.BLACK
) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	if emission != Color.BLACK:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = 1.0
	return material


func _create_environment() -> void:
	_world_environment = WorldEnvironment.new()
	_world_environment.name = "Environnement"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#080d12")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#9db6c2")
	environment.ambient_light_energy = 0.32
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	_world_environment.environment = environment
	add_child(_world_environment)


func _create_architecture() -> void:
	_architecture = Node3D.new()
	_architecture.name = "ArchitectureTemoin"
	add_child(_architecture)

	_add_box(
		_architecture, "Sol", Vector3(12.0, 0.2, 38.0),
		Vector3(0.0, -0.1, -8.0), _materials["concrete"], true
	)
	_add_box(
		_architecture, "MurGauche", Vector3(0.3, 4.0, 38.0),
		Vector3(-6.0, 2.0, -8.0), _materials["concrete_dark"], true
	)
	_add_box(
		_architecture, "MurDroit", Vector3(0.3, 4.0, 38.0),
		Vector3(6.0, 2.0, -8.0), _materials["concrete_dark"], true
	)
	_add_box(
		_architecture, "Fond", Vector3(12.0, 4.0, 0.3),
		Vector3(0.0, 2.0, -27.0), _materials["concrete_dark"], true
	)

	for z_position: float in [9.0, 3.0, -3.0, -9.0, -15.0, -21.0, -26.5]:
		_add_frame(_architecture, z_position)

	for z_position: float in [7.0, 1.0, -5.0, -11.0, -17.0, -23.0]:
		_add_box(
			_architecture, "Plafond",
			Vector3(10.8, 0.18, 2.8),
			Vector3(0.0, 4.05, z_position),
			_materials["steel_dark"]
		)
		_add_box(
			_architecture, "BandeauCyan",
			Vector3(0.12, 0.02, 4.0),
			Vector3(0.0, 0.02, z_position),
			_materials["cyan"]
		)

	_create_security_door(_architecture)
	_create_medical_alcove(_architecture)
	_create_preview_stage(_architecture)
	_create_scale_reference(_architecture)


func _add_frame(parent: Node3D, z_position: float) -> void:
	_add_box(
		parent, "CadreGauche", Vector3(0.45, 4.3, 0.45),
		Vector3(-5.55, 2.05, z_position), _materials["steel_dark"], true
	)
	_add_box(
		parent, "CadreDroit", Vector3(0.45, 4.3, 0.45),
		Vector3(5.55, 2.05, z_position), _materials["steel_dark"], true
	)
	_add_box(
		parent, "CadreHaut", Vector3(11.55, 0.45, 0.45),
		Vector3(0.0, 4.0, z_position), _materials["steel_dark"]
	)


func _create_security_door(parent: Node3D) -> void:
	_add_box(
		parent, "PorteTemoin", Vector3(0.22, 2.8, 2.1),
		Vector3(-5.76, 1.4, 2.5), _materials["steel"], true
	)
	_add_box(
		parent, "PorteInset", Vector3(0.24, 1.85, 1.2),
		Vector3(-5.62, 1.4, 2.5), _materials["steel_dark"]
	)
	_add_box(
		parent, "IndicateurPorte", Vector3(0.12, 0.22, 0.48),
		Vector3(-5.5, 2.9, 2.5), _materials["amber"]
	)


func _create_medical_alcove(parent: Node3D) -> void:
	_add_box(
		parent, "FondMedical", Vector3(7.0, 3.2, 0.25),
		Vector3(0.0, 1.6, -26.7), _materials["clinical"]
	)
	for x_position: float in [-2.4, 0.0, 2.4]:
		_add_box(
			parent, "Rayonnage", Vector3(1.8, 0.12, 0.6),
			Vector3(x_position, 1.0, -26.25), _materials["steel"]
		)
		_add_box(
			parent, "Rayonnage", Vector3(1.8, 0.12, 0.6),
			Vector3(x_position, 2.0, -26.25), _materials["steel"]
		)
	_add_box(
		parent, "SignalMedical", Vector3(1.0, 1.0, 0.06),
		Vector3(0.0, 2.75, -26.5), _materials["cyan"]
	)


func _create_preview_stage(parent: Node3D) -> void:
	_add_box(
		parent, "SocleAsset", Vector3(4.0, 0.22, 4.0),
		Vector3(0.0, 0.11, -12.5), _materials["steel"]
	)
	_add_box(
		parent, "RepereSocle", Vector3(4.2, 0.03, 0.08),
		Vector3(0.0, 0.24, -10.45), _materials["amber"]
	)
	_asset_anchor = Node3D.new()
	_asset_anchor.name = "AssetPreview"
	_asset_anchor.position = Vector3(0.0, 0.22, -12.5)
	add_child(_asset_anchor)

	_placeholder = Node3D.new()
	_placeholder.name = "Placeholder"
	_asset_anchor.add_child(_placeholder)
	_add_box(
		_placeholder, "PlaceholderCorps", Vector3(0.8, 1.2, 0.45),
		Vector3(0.0, 0.9, 0.0), _materials["concrete"]
	)
	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.28
	head_mesh.height = 0.56
	head_mesh.radial_segments = 8
	head_mesh.rings = 4
	head_mesh.material = _materials["clinical"]
	head.mesh = head_mesh
	head.position.y = 1.75
	_placeholder.add_child(head)


func _create_scale_reference(parent: Node3D) -> void:
	for height_index: int in range(1, 4):
		_add_box(
			parent, "RepereMetre",
			Vector3(0.5, 0.025, 0.05),
			Vector3(2.35, float(height_index), -12.45),
			_materials["cyan"]
		)
	_add_box(
		parent, "RegleVerticale", Vector3(0.04, 3.0, 0.05),
		Vector3(2.58, 1.5, -12.45), _materials["cyan"]
	)


func _add_box(
	parent: Node3D,
	node_name: String,
	size: Vector3,
	node_position: Vector3,
	material: Material,
	with_collision: bool = false
) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = material
	instance.mesh = mesh
	instance.position = node_position
	parent.add_child(instance)

	if with_collision:
		var body := StaticBody3D.new()
		body.name = "%sCollision" % node_name
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		body.position = node_position
		body.add_child(collision)
		parent.add_child(body)
	return instance


func _create_lighting() -> void:
	var main_light := DirectionalLight3D.new()
	main_light.name = "LumierePrincipale"
	main_light.rotation_degrees = Vector3(-55.0, -25.0, 0.0)
	main_light.light_color = Color("#bfd6df")
	main_light.light_energy = 0.55
	main_light.shadow_enabled = true
	add_child(main_light)

	for light_data: Dictionary in [
		{"position": Vector3(0.0, 3.5, 5.0), "color": Color("#cce8ed")},
		{"position": Vector3(0.0, 3.5, -7.0), "color": CYAN},
		{"position": Vector3(-4.8, 2.7, 2.5), "color": AMBER},
		{"position": Vector3(0.0, 3.2, -21.0), "color": RED},
	]:
		var light := OmniLight3D.new()
		light.position = light_data["position"]
		light.light_color = light_data["color"]
		light.light_energy = 2.0
		light.omni_range = 8.0
		light.shadow_enabled = false
		add_child(light)
		_accent_lights.append(light)
	_apply_light_mode()


func _create_player() -> void:
	_player = CharacterBody3D.new()
	_player.name = "VisiteurFPS"
	_player.set_script(preload("res://scripts/controleur_fps.gd"))
	_player.position = Vector3(0.0, 0.02, 9.5)
	add_child(_player)


func _create_interface() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "Interface"
	add_child(canvas)

	_help_background = ColorRect.new()
	_help_background.position = Vector2(16.0, 16.0)
	_help_background.size = Vector2(520.0, 210.0)
	_help_background.color = Color(0.035, 0.055, 0.075, 0.9)
	canvas.add_child(_help_background)

	_help_label = Label.new()
	_help_label.position = Vector2(30.0, 28.0)
	_help_label.text = (
		"LABORATOIRE VISUEL — F1 masque l'aide\n"
		+ "ZQSD / WASD / flèches : déplacement   Souris : regard\n"
		+ "Maj : course   Échap : libérer/capturer la souris\n"
		+ "F2 : ambiance froide / neutre / alerte\n"
		+ "F3 : vignette suivante   F4 : menu de sélection\n"
		+ "Page préc./suiv. : changer d'asset   R : rotation 45°\n"
		+ "- / + : échelle de prévisualisation"
	)
	_help_label.add_theme_color_override("font_color", Color("#d7e0e2"))
	_help_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	_help_label.add_theme_constant_override("shadow_offset_x", 1)
	_help_label.add_theme_constant_override("shadow_offset_y", 1)
	canvas.add_child(_help_label)

	var status_background := ColorRect.new()
	status_background.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	status_background.offset_top = -54.0
	status_background.color = Color(0.035, 0.055, 0.075, 0.88)
	canvas.add_child(status_background)

	_status_label = Label.new()
	_status_label.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_status_label.offset_top = -42.0
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.add_theme_color_override("font_color", CYAN)
	canvas.add_child(_status_label)

	var crosshair := Label.new()
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-5.0, -12.0)
	crosshair.text = "+"
	crosshair.add_theme_color_override("font_color", Color(0.85, 0.9, 0.92, 0.65))
	canvas.add_child(crosshair)


func _create_selection_menu() -> void:
	var menu_canvas := CanvasLayer.new()
	menu_canvas.name = "InterfaceSelection"
	add_child(menu_canvas)
	_selection_menu = PanelContainer.new()
	_selection_menu.name = "MenuSelection"
	_selection_menu.position = Vector2(16.0, 240.0)
	_selection_menu.size = Vector2(430.0, 610.0)
	_selection_menu.visible = false
	menu_canvas.add_child(_selection_menu)

	var scroll := ScrollContainer.new()
	_selection_menu.add_child(scroll)
	var entries := VBoxContainer.new()
	entries.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(entries)
	_add_menu_title(entries, "SÉLECTION DU LABORATOIRE")
	_add_menu_button(entries, "Architecture témoin", Callable(self, "_select_architecture"))
	_add_menu_title(entries, "Vignettes existantes")
	for entry: Dictionary in [
		{"label": "Couloir", "index": 0},
		{"label": "Angle", "index": 1},
		{"label": "Petite salle", "index": 2},
		{"label": "Porte", "index": 3},
		{"label": "Matériaux et signalétique", "index": 4},
	]:
		_add_menu_button(entries, entry.label, Callable(self, "_select_validation_vignette").bind(entry.index))
	_add_menu_title(entries, "Vignettes de zones phase 3")
	for entry: Dictionary in [
		{"label": "Accueil sécurisé", "index": 5},
		{"label": "Couloirs de confinement", "index": 6},
		{"label": "Entrepôt médical", "index": 7},
		{"label": "Laboratoire de synthèse", "index": 8},
		{"label": "Salle d'extraction", "index": 9},
	]:
		_add_menu_button(entries, entry.label, Callable(self, "_select_validation_vignette").bind(entry.index))
	_add_menu_title(entries, "Zones complètes phase 3")
	for entry: Dictionary in [
		{"label": "Zone complète — Accueil", "index": 10},
		{"label": "Zone complète — Confinement", "index": 11},
		{"label": "Zone complète — Entrepôt médical", "index": 12},
		{"label": "Zone complète — Synthèse", "index": 13},
		{"label": "Zone complète — Extraction", "index": 14},
	]:
		_add_menu_button(entries, entry.label, Callable(self, "_select_validation_vignette").bind(entry.index))
	_add_menu_title(entries, "Assets phase 3")
	for asset_path: String in _asset_paths:
		if asset_path.begins_with(PHASE3_ASSETS_PATH):
			_add_menu_button(entries, asset_path.get_file(), Callable(self, "_select_asset_path").bind(asset_path))
	_add_menu_title(entries, "Assets phase 4")
	for asset_path: String in _asset_paths:
		if asset_path.begins_with(PHASE4_ASSETS_PATH):
			_add_menu_button(entries, asset_path.get_file(), Callable(self, "_select_asset_path").bind(asset_path))
	_add_menu_title(entries, "Assets phase 5 — Arsenal FPS")
	for asset_path: String in _asset_paths:
		if asset_path.begins_with(PHASE5_ASSETS_PATH):
			_add_menu_button(entries, asset_path.get_file(), Callable(self, "_select_asset_path").bind(asset_path))
	_add_menu_title(entries, "Assets phase 6 — Achats et quête")
	for asset_path: String in _asset_paths:
		if asset_path.begins_with(PHASE6_ASSETS_PATH):
			_add_menu_button(entries, asset_path.get_file(), Callable(self, "_select_asset_path").bind(asset_path))


func _add_menu_title(parent: VBoxContainer, title: String) -> void:
	var label := Label.new()
	label.text = title
	label.add_theme_color_override("font_color", CYAN)
	label.add_theme_font_size_override("font_size", 16)
	parent.add_child(label)


func _add_menu_button(parent: VBoxContainer, label_text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = label_text
	button.custom_minimum_size = Vector2(390.0, 30.0)
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.pressed.connect(callback)
	parent.add_child(button)


func _set_selection_menu_visible(visible: bool) -> void:
	_selection_menu.visible = visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if visible else Input.MOUSE_MODE_CAPTURED)


func _select_architecture() -> void:
	_exit_validation_mode()
	_set_selection_menu_visible(false)
	_update_status("Architecture témoin")


func _select_validation_vignette(index: int) -> void:
	if _validation_index >= 0:
		_validation_vignettes[_validation_index].visible = false
	_validation_index = index
	_validation_vignettes[_validation_index].visible = true
	_architecture.visible = false
	_asset_anchor.visible = false
	_place_player_for_vignette()
	_set_selection_menu_visible(false)
	_update_status()


func _select_asset_path(asset_path: String) -> void:
	var index := _asset_paths.find(asset_path)
	if index < 0:
		_update_status("Asset introuvable")
		return
	_exit_validation_mode()
	_asset_index = index
	_asset_scale = 1.0
	_show_asset()
	_place_player_for_asset()
	_set_selection_menu_visible(false)


func _discover_assets() -> void:
	_asset_paths.clear()
	var directory := DirAccess.open(IMPORTS_PATH)
	if directory == null:
		_update_status()
		return
	for file_name: String in directory.get_files():
		var extension := file_name.get_extension().to_lower()
		if extension in ALLOWED_EXTENSIONS:
			_asset_paths.append("%s/%s" % [IMPORTS_PATH, file_name])
	var phase3_directory := DirAccess.open(PHASE3_ASSETS_PATH)
	if phase3_directory != null:
		for file_name: String in phase3_directory.get_files():
			if file_name.get_extension().to_lower() == "glb":
				_asset_paths.append("%s/%s" % [PHASE3_ASSETS_PATH, file_name])
	var phase4_directory := DirAccess.open(PHASE4_ASSETS_PATH)
	if phase4_directory != null:
		for file_name: String in phase4_directory.get_files():
			if file_name.get_extension().to_lower() == "glb":
				_asset_paths.append("%s/%s" % [PHASE4_ASSETS_PATH, file_name])
	var phase5_directory := DirAccess.open(PHASE5_ASSETS_PATH)
	if phase5_directory != null:
		for file_name: String in phase5_directory.get_files():
			if file_name.get_extension().to_lower() == "glb":
				_asset_paths.append("%s/%s" % [PHASE5_ASSETS_PATH, file_name])
	var phase6_directory := DirAccess.open(PHASE6_ASSETS_PATH)
	if phase6_directory != null:
		for file_name: String in phase6_directory.get_files():
			if file_name.get_extension().to_lower() == "glb":
				_asset_paths.append("%s/%s" % [PHASE6_ASSETS_PATH, file_name])
	_asset_paths.sort()
	if not _asset_paths.is_empty():
		_asset_index = 0
		_show_asset()
	else:
		_update_status()


func _change_asset(direction: int) -> void:
	_exit_validation_mode()
	if _asset_paths.is_empty():
		_update_status()
		return
	_asset_index = wrapi(_asset_index + direction, 0, _asset_paths.size())
	_asset_scale = 1.0
	_show_asset()


func _show_asset() -> void:
	if is_instance_valid(_preview_instance):
		_preview_instance.queue_free()
		_preview_instance = null
	var instance := _instantiate_asset(_asset_paths[_asset_index])
	if instance == null:
		_update_status("La racine de l'asset doit être un Node3D")
		return
	_preview_instance = instance
	_preview_instance.name = "AssetActif"
	_preview_instance.scale = Vector3.ONE * _asset_scale
	_asset_anchor.add_child(_preview_instance)
	_placeholder.visible = false
	_update_status()


func _instantiate_asset(asset_path: String) -> Node3D:
	var extension := asset_path.get_extension().to_lower()
	if extension in ["glb", "gltf"]:
		var document := GLTFDocument.new()
		var state := GLTFState.new()
		var parse_error := document.append_from_file(ProjectSettings.globalize_path(asset_path), state)
		if parse_error != OK:
			return null
		var generated_scene := document.generate_scene(state)
		if generated_scene is Node3D:
			return generated_scene as Node3D
		if generated_scene != null:
			generated_scene.queue_free()
		return null

	var resource := load(asset_path)
	if resource is not PackedScene:
		return null
	var instance := (resource as PackedScene).instantiate()
	if instance is Node3D:
		return instance as Node3D
	instance.queue_free()
	return null


func _create_validation_vignettes() -> void:
	_validation_root = Node3D.new()
	_validation_root.name = "VignettesValidation"
	add_child(_validation_root)
	_validation_vignettes = [
		_create_corridor_vignette(),
		_create_corner_vignette(),
		_create_room_vignette(),
		_create_door_vignette(),
		_create_phase2_vignette(),
		_create_phase3_accueil_vignette(),
		_create_phase3_confinement_vignette(),
		_create_phase3_medical_vignette(),
		_create_phase3_synthese_vignette(),
		_create_phase3_extraction_vignette(),
		_create_full_zone_vignette("ZoneCompleteAccueil", "np_z03_zone_accueil.glb", Vector2(16.0, 16.0)),
		_create_full_zone_vignette("ZoneCompleteConfinement", "np_z03_zone_confinement.glb", Vector2(6.0, 24.0)),
		_create_full_zone_vignette("ZoneCompleteEntrepotMedical", "np_z03_zone_entrepot_medical.glb", Vector2(16.0, 20.0)),
		_create_full_zone_vignette("ZoneCompleteSynthese", "np_z03_zone_synthese.glb", Vector2(16.0, 16.0)),
		_create_full_zone_vignette("ZoneCompleteExtraction", "np_z03_zone_extraction.glb", Vector2(20.0, 20.0)),
	]
	for vignette: Node3D in _validation_vignettes:
		vignette.visible = false


func _create_vignette(name: String) -> Node3D:
	var vignette := Node3D.new()
	vignette.name = name
	_validation_root.add_child(vignette)
	return vignette


func _add_module(
	parent: Node3D,
	file_name: String,
	module_position: Vector3,
	rotation_y_degrees: float = 0.0
) -> void:
	var module_path := "%s/%s" % [IMPORTS_PATH, file_name]
	var glb_path := "%s/%s.glb" % [IMPORTS_PATH, file_name.get_basename()]
	if FileAccess.file_exists(glb_path):
		module_path = glb_path
	var node := _instantiate_asset(module_path)
	if node == null:
		push_error("Module de validation incompatible : %s" % module_path)
		return
	node.position = module_position
	node.rotation_degrees.y = rotation_y_degrees
	parent.add_child(node)


func _create_corridor_vignette() -> Node3D:
	var vignette := _create_vignette("VignetteCouloir")
	for x_position: float in [-2.0, 0.0, 2.0]:
		for z_position: float in [8.0, 6.0, 4.0, 2.0, 0.0, -2.0]:
			_add_module(vignette, "np_kms_01_sol_droit.tscn", Vector3(x_position, 0.0, z_position))
			_add_module(vignette, "np_kms_10_plafond_plein.tscn", Vector3(x_position, 3.5, z_position))
	for z_position: float in [8.0, 6.0, 4.0, 2.0, 0.0, -2.0]:
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(-3.1, 0.0, z_position), 90.0)
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(3.1, 0.0, z_position), -90.0)
	for z_position: float in [9.0, 5.0, 1.0, -3.0]:
		_add_module(vignette, "np_kms_20_pilier.tscn", Vector3(-3.1, 0.0, z_position))
		_add_module(vignette, "np_kms_20_pilier.tscn", Vector3(3.1, 0.0, z_position))
	for z_position: float in [9.0, -3.0]:
		for x_position: float in [-2.0, 0.0, 2.0]:
			_add_module(vignette, "np_kms_21_poutre.tscn", Vector3(x_position, 3.35, z_position))
	for z_position: float in [5.0, 1.0]:
		_add_module(vignette, "np_kms_22_couvre_joint_vertical.tscn", Vector3(-3.11, 0.0, z_position))
		_add_module(vignette, "np_kms_22_couvre_joint_vertical.tscn", Vector3(3.11, 0.0, z_position))
		_add_module(vignette, "np_kms_23_couvre_joint_horizontal.tscn", Vector3(-1.0, 3.34, z_position))
		_add_module(vignette, "np_kms_23_couvre_joint_horizontal.tscn", Vector3(1.0, 3.34, z_position))
	return vignette


func _create_corner_vignette() -> Node3D:
	var vignette := _create_vignette("VignetteAngle")
	for x_position: float in [-2.0, 0.0, 2.0]:
		for z_position: float in [8.0, 6.0, 4.0]:
			_add_module(vignette, "np_kms_02_sol_angle.tscn", Vector3(x_position, 0.0, z_position))
			_add_module(vignette, "np_kms_10_plafond_plein.tscn", Vector3(x_position, 3.5, z_position))
	for z_position: float in [8.0, 6.0, 4.0]:
		_add_module(vignette, "np_kms_07_angle_interieur.tscn", Vector3(-3.0, 0.0, z_position))
		_add_module(vignette, "np_kms_08_angle_exterieur.tscn", Vector3(3.0, 0.0, z_position), 180.0)
	return vignette


func _create_room_vignette() -> Node3D:
	var vignette := _create_vignette("VignetteSalle")
	for x_position: float in [-3.0, -1.0, 1.0, 3.0]:
		for z_position: float in [7.0, 5.0, 3.0, 1.0]:
			_add_module(vignette, "np_kms_01_sol_droit.tscn", Vector3(x_position, 0.0, z_position))
			_add_module(vignette, "np_kms_11_plafond_technique.tscn", Vector3(x_position, 3.5, z_position))
	for x_position: float in [-3.0, -1.0, 1.0, 3.0]:
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(x_position, 0.0, 8.1), 180.0)
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(x_position, 0.0, -0.1))
	for z_position: float in [7.0, 5.0, 3.0, 1.0]:
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(-4.1, 0.0, z_position), 90.0)
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(4.1, 0.0, z_position), -90.0)
	return vignette


func _create_door_vignette() -> Node3D:
	var vignette := _create_vignette("VignettePorte")
	for x_position: float in [-2.0, 0.0, 2.0]:
		_add_module(vignette, "np_kms_01_sol_droit.tscn", Vector3(x_position, 0.0, 6.0))
		_add_module(vignette, "np_kms_10_plafond_plein.tscn", Vector3(x_position, 3.5, 6.0))
	for x_position: float in [-1.0, 1.0]:
		_add_module(vignette, "np_kms_04_sol_transition.tscn", Vector3(x_position, 0.0, 4.5))
	_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(-3.1, 0.0, 6.0), 90.0)
	_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(3.1, 0.0, 6.0), -90.0)
	_add_module(vignette, "np_kms_13_encadrement_simple.tscn", Vector3(0.0, 0.0, 3.9), 180.0)
	_add_module(vignette, "np_kms_15_porte_accueil_couloirs.tscn", Vector3(0.0, 0.0, 3.78), 180.0)
	return vignette


func _create_phase2_vignette() -> Node3D:
	var vignette := _create_vignette("VignetteMateriauxSignaletique")
	_add_box(vignette, "SolBétonClair", Vector3(12.0, 0.2, 15.0), Vector3(0.0, -0.1, 2.0), _phase2_material("concrete_light"), true)
	_add_box(vignette, "MurFondBétonSombre", Vector3(12.0, 4.0, 0.2), Vector3(0.0, 2.0, -5.0), _phase2_material("concrete_dark"), true)
	_add_box(vignette, "MurGaucheAcierBrut", Vector3(0.2, 4.0, 15.0), Vector3(-5.9, 2.0, 2.0), _phase2_material("steel_raw"), true)
	_add_box(vignette, "MurDroitAcierPeint", Vector3(0.2, 4.0, 15.0), Vector3(5.9, 2.0, 2.0), _phase2_material("steel_painted"), true)
	_add_box(vignette, "PlafondAcierBrut", Vector3(12.0, 0.18, 15.0), Vector3(0.0, 4.1, 2.0), _phase2_material("steel_raw"))
	_add_box(vignette, "PanneauCompositeMédical", Vector3(2.2, 2.2, 0.08), Vector3(-4.5, 1.8, 5.5), _phase2_material("clinical"))
	_add_box(vignette, "VitreRenforcée", Vector3(2.2, 2.2, 0.08), Vector3(-4.35, 1.8, 5.35), _phase2_material("glass"))
	_add_label3d(vignette, "COMPOSITE\nMÉDICAL", Vector3(-4.5, 1.8, 5.56), Color("#111820"), 44)
	_add_label3d(vignette, "VERRE\nRENFORCÉ", Vector3(-4.5, 0.65, 5.56), Color("#d7e0e2"), 36)

	_add_sector_panel(vignette, "A", "ACCUEIL", Vector3(-4.0, 2.15, -4.85), _phase2_material("cyan"))
	_add_sector_panel(vignette, "C", "CONFINEMENT", Vector3(-2.0, 2.15, -4.85), _phase2_material("amber"))
	_add_sector_panel(vignette, "M", "MÉDICAL", Vector3(0.0, 2.15, -4.85), _phase2_material("clinical"))
	_add_sector_panel(vignette, "S", "SYNTHÈSE", Vector3(2.0, 2.15, -4.85), _phase2_material("danger"))
	_add_sector_panel(vignette, "E", "EXTRACTION", Vector3(4.0, 2.15, -4.85), _phase2_material("cyan"))

	_add_door_state_panel(vignette, "FERMÉ", Vector3(-4.0, 1.25, 2.2), _phase2_material("steel_painted"))
	_add_door_state_panel(vignette, "ACHETABLE", Vector3(-2.0, 1.25, 2.2), _phase2_material("amber"))
	_add_door_state_panel(vignette, "REFUSÉ", Vector3(0.0, 1.25, 2.2), _phase2_material("danger"))
	_add_door_state_panel(vignette, "ACHETÉ", Vector3(2.0, 1.25, 2.2), _material(Color("#71c982"), 0.55, 0.05, Color("#71c982") * 0.18))
	_add_door_state_panel(vignette, "OUVERT", Vector3(4.0, 1.25, 2.2), _phase2_material("cyan"))
	_add_label3d(vignette, "PHASE 2 — MATÉRIAUX ET SIGNALÉTIQUE", Vector3(0.0, 3.65, 6.5), Color("#d7e0e2"), 38)
	return vignette


func _add_phase3_asset(
	parent: Node3D,
	file_name: String,
	asset_position: Vector3,
	rotation_y_degrees: float = 0.0
) -> void:
	var node := _instantiate_asset("%s/%s" % [PHASE3_ASSETS_PATH, file_name])
	if node == null:
		push_error("Asset phase 3 incompatible : %s" % file_name)
		return
	node.position = asset_position
	node.rotation_degrees.y = rotation_y_degrees
	parent.add_child(node)


func _add_phase3_room_shell(vignette: Node3D, open_ceiling: bool = false) -> void:
	for x_position: float in [-3.0, -1.0, 1.0, 3.0]:
		for z_position: float in [7.0, 5.0, 3.0, 1.0]:
			_add_module(vignette, "np_kms_01_sol_droit.tscn", Vector3(x_position, 0.0, z_position))
			if not open_ceiling:
				_add_module(vignette, "np_kms_11_plafond_technique.tscn", Vector3(x_position, 3.5, z_position))
	for x_position: float in [-3.0, -1.0, 1.0, 3.0]:
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(x_position, 0.0, 8.1), 180.0)
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(x_position, 0.0, -0.1))
	for z_position: float in [7.0, 5.0, 3.0, 1.0]:
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(-4.1, 0.0, z_position), 90.0)
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(4.1, 0.0, z_position), -90.0)


func _create_phase3_accueil_vignette() -> Node3D:
	var vignette := _create_vignette("VignettePhase3Accueil")
	_add_phase3_room_shell(vignette)
	_add_phase3_asset(vignette, "np_z03_accueil_banque.glb", Vector3(-2.55, 0.0, 4.6), -90.0)
	_add_phase3_asset(vignette, "np_z03_accueil_portillon.glb", Vector3(2.9, 0.0, 5.7), 90.0)
	_add_phase3_asset(vignette, "np_z03_commun_equipement_mural.glb", Vector3(-3.92, 1.1, 2.7), 90.0)
	return vignette


func _create_phase3_confinement_vignette() -> Node3D:
	var vignette := _create_vignette("VignettePhase3Confinement")
	for x_position: float in [-2.0, 0.0, 2.0]:
		for z_position: float in [8.0, 6.0, 4.0, 2.0, 0.0, -2.0]:
			_add_module(vignette, "np_kms_01_sol_droit.tscn", Vector3(x_position, 0.0, z_position))
			_add_module(vignette, "np_kms_10_plafond_plein.tscn", Vector3(x_position, 3.5, z_position))
	for z_position: float in [8.0, 6.0, 4.0, 2.0, 0.0, -2.0]:
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(-3.1, 0.0, z_position), 90.0)
		_add_module(vignette, "np_kms_05_mur_plein.tscn", Vector3(3.1, 0.0, z_position), -90.0)
	_add_phase3_asset(vignette, "np_z03_confinement_barriere.glb", Vector3(-2.75, 0.0, 4.0), 90.0)
	_add_phase3_asset(vignette, "np_z03_commun_cable_fixe.glb", Vector3(0.0, 3.0, 5.8))
	_add_phase3_asset(vignette, "np_z03_commun_equipement_mural.glb", Vector3(2.94, 1.1, 2.0), -90.0)
	return vignette


func _create_phase3_medical_vignette() -> Node3D:
	var vignette := _create_vignette("VignettePhase3Medical")
	_add_phase3_room_shell(vignette)
	for z_position: float in [2.4, 5.4]:
		_add_phase3_asset(vignette, "np_z03_medical_rayonnage.glb", Vector3(-3.55, 0.0, z_position), 90.0)
		_add_phase3_asset(vignette, "np_z03_medical_rayonnage.glb", Vector3(3.55, 0.0, z_position), -90.0)
		_add_phase3_asset(vignette, "np_z03_medical_bac.glb", Vector3(-3.55, 0.88, z_position), 90.0)
	_add_phase3_asset(vignette, "np_z03_medical_chariot.glb", Vector3(2.8, 0.0, 2.1), -90.0)
	return vignette


func _create_phase3_synthese_vignette() -> Node3D:
	var vignette := _create_vignette("VignettePhase3Synthese")
	_add_phase3_room_shell(vignette)
	_add_phase3_asset(vignette, "np_z03_synthese_paillasse.glb", Vector3(-2.8, 0.0, 4.5), -90.0)
	_add_phase3_asset(vignette, "np_z03_synthese_cuve.glb", Vector3(3.3, 0.0, 4.3), 90.0)
	_add_phase3_asset(vignette, "np_z03_synthese_console.glb", Vector3(3.72, 0.0, 2.2), -90.0)
	_add_phase3_asset(vignette, "np_z03_synthese_observation.glb", Vector3(3.92, 0.0, 6.0), -90.0)
	_add_phase3_asset(vignette, "np_z03_commun_cable_fixe.glb", Vector3(0.0, 3.0, 6.0))
	return vignette


func _create_phase3_extraction_vignette() -> Node3D:
	var vignette := _create_vignette("VignettePhase3Extraction")
	_add_phase3_room_shell(vignette, true)
	_add_phase3_asset(vignette, "np_z03_extraction_balise.glb", Vector3(-3.55, 0.0, 5.8))
	_add_phase3_asset(vignette, "np_z03_extraction_balise.glb", Vector3(3.55, 0.0, 5.8))
	_add_phase3_asset(vignette, "np_z03_commun_equipement_mural.glb", Vector3(-3.92, 1.1, 2.5), 90.0)
	_add_phase3_asset(vignette, "np_z03_commun_equipement_mural.glb", Vector3(3.92, 1.1, 2.5), -90.0)
	return vignette


func _create_full_zone_vignette(name: String, file_name: String, floor_size: Vector2) -> Node3D:
	var vignette := _create_vignette(name)
	var zone := _instantiate_asset("%s/%s" % [PHASE3_ZONES_PATH, file_name])
	if zone == null:
		push_error("Zone complète incompatible : %s" % file_name)
		return vignette
	vignette.add_child(zone)
	_add_lab_floor_collision(vignette, floor_size)
	return vignette


func _add_lab_floor_collision(parent: Node3D, floor_size: Vector2) -> void:
	_add_lab_collision_box(parent, "Sol", Vector3(floor_size.x, 0.2, floor_size.y), Vector3(0.0, -0.1, 0.0))
	_add_lab_collision_box(parent, "MurGauche", Vector3(0.2, 4.0, floor_size.y), Vector3(-floor_size.x * 0.5, 2.0, 0.0))
	_add_lab_collision_box(parent, "MurDroit", Vector3(0.2, 4.0, floor_size.y), Vector3(floor_size.x * 0.5, 2.0, 0.0))
	_add_lab_collision_box(parent, "MurAvant", Vector3(floor_size.x, 4.0, 0.2), Vector3(0.0, 2.0, floor_size.y * 0.5))
	_add_lab_collision_box(parent, "MurArriere", Vector3(floor_size.x, 4.0, 0.2), Vector3(0.0, 2.0, -floor_size.y * 0.5))


func _add_lab_collision_box(parent: Node3D, node_name: String, size: Vector3, position: Vector3) -> void:
	var body := StaticBody3D.new()
	body.name = "CollisionLaboratoire%s" % node_name
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.position = position
	body.add_child(collision)
	parent.add_child(body)


func _add_sector_panel(parent: Node3D, sector: String, label: String, position: Vector3, material: Material) -> void:
	_add_box(parent, "Secteur%s" % sector, Vector3(1.6, 1.5, 0.08), position, material)
	_add_label3d(parent, sector, position + Vector3(0.0, 0.28, 0.06), Color("#111820"), 96)
	_add_label3d(parent, label, position + Vector3(0.0, -0.45, 0.06), Color("#111820"), 24)


func _add_door_state_panel(parent: Node3D, label: String, position: Vector3, material: Material) -> void:
	_add_box(parent, "État%s" % label, Vector3(1.6, 0.78, 0.08), position, material)
	_add_label3d(parent, label, position + Vector3(0.0, 0.0, 0.06), Color("#111820"), 30)


func _add_label3d(parent: Node3D, label_text: String, position: Vector3, color: Color, size: int) -> void:
	var label := Label3D.new()
	label.text = label_text
	label.position = position
	label.pixel_size = 0.005
	label.font_size = size
	label.outline_size = 6
	label.modulate = color
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	label.rotation_degrees.y = 180.0
	label.scale.x = -1.0
	label.no_depth_test = true
	parent.add_child(label)


func _change_validation_vignette() -> void:
	if _validation_vignettes.is_empty():
		return
	if _validation_index >= 0:
		_validation_vignettes[_validation_index].visible = false
	_validation_index = wrapi(_validation_index + 1, 0, _validation_vignettes.size())
	_validation_vignettes[_validation_index].visible = true
	_architecture.visible = false
	_asset_anchor.visible = false
	_place_player_for_vignette()
	_update_status()


func _place_player_for_vignette() -> void:
	var positions := [
		Vector3(0.0, 0.02, 9.5), Vector3(0.0, 0.02, 9.5), Vector3(0.0, 0.02, 9.5),
		Vector3(0.0, 0.02, 9.5), Vector3(0.0, 0.02, 9.5), Vector3(0.0, 0.02, 9.5),
		Vector3(0.0, 0.02, 9.5), Vector3(0.0, 0.02, 9.5), Vector3(0.0, 0.02, 9.5),
		Vector3(0.0, 0.02, 9.5), Vector3(0.0, 0.02, 6.0), Vector3(0.0, 0.02, 10.0),
		Vector3(0.0, 0.02, 8.0), Vector3(0.0, 0.02, 6.0), Vector3(0.0, 0.02, 8.0),
	]
	_player.position = positions[_validation_index]


func _place_player_for_asset() -> void:
	_player.position = Vector3(0.0, 0.02, -8.0)
	_player.rotation = Vector3.ZERO


func _exit_validation_mode() -> void:
	if _validation_index < 0:
		return
	_validation_vignettes[_validation_index].visible = false
	_validation_index = -1
	_architecture.visible = true
	_asset_anchor.visible = true


func _change_asset_scale(factor: float) -> void:
	if not is_instance_valid(_preview_instance):
		return
	_asset_scale = clampf(_asset_scale * factor, 0.05, 20.0)
	_preview_instance.scale = Vector3.ONE * _asset_scale
	_update_status()


func _apply_light_mode() -> void:
	var environment := _world_environment.environment
	match _light_mode:
		0:
			environment.ambient_light_color = Color("#9db6c2")
			environment.ambient_light_energy = 0.32
			_set_accent_colors([Color("#cce8ed"), CYAN, AMBER, RED])
		1:
			environment.ambient_light_color = Color("#d7e0e2")
			environment.ambient_light_energy = 0.48
			_set_accent_colors([
				Color("#d7e0e2"), Color("#d7e0e2"),
				Color("#d7e0e2"), Color("#d7e0e2")
			])
		2:
			environment.ambient_light_color = Color("#693d42")
			environment.ambient_light_energy = 0.28
			_set_accent_colors([Color("#d7e0e2"), RED, AMBER, RED])
	_update_status()


func _set_accent_colors(colors: Array[Color]) -> void:
	for index: int in range(mini(_accent_lights.size(), colors.size())):
		_accent_lights[index].light_color = colors[index]


func _update_status(message: String = "") -> void:
	if not is_instance_valid(_status_label):
		return
	var light_names := ["froide", "neutre", "alerte"]
	var asset_name := "placeholder procédural"
	if _validation_index >= 0:
		asset_name = [
			"couloir", "angle", "petite salle", "porte", "matériaux et signalétique",
			"phase 3 — accueil", "phase 3 — confinement", "phase 3 — entrepôt médical",
			"phase 3 — laboratoire de synthèse", "phase 3 — extraction",
			"zone complète — accueil", "zone complète — confinement",
			"zone complète — entrepôt médical", "zone complète — synthèse",
			"zone complète — extraction"
		][_validation_index]
	elif not _asset_paths.is_empty() and _asset_index >= 0:
		asset_name = _asset_paths[_asset_index].get_file()
	var suffix := ""
	if not message.is_empty():
		suffix = " — %s" % message
	_status_label.text = (
		"Vue : %s | Échelle : %.2f | Ambiance : %s%s"
		% [asset_name, _asset_scale, light_names[_light_mode], suffix]
	)
