extends Node3D

const IMPORTS_PATH := "res://imports"
const ALLOWED_EXTENSIONS := ["glb", "gltf", "tscn"]
const CYAN := Color("#40d5db")
const AMBER := Color("#f0a43a")
const RED := Color("#d94b4b")

var _materials: Dictionary[String, StandardMaterial3D] = {}
var _world_environment: WorldEnvironment
var _accent_lights: Array[OmniLight3D] = []
var _asset_anchor: Node3D
var _placeholder: Node3D
var _preview_instance: Node3D
var _asset_paths: PackedStringArray = []
var _asset_index := -1
var _asset_scale := 1.0
var _light_mode := 0
var _help_visible := true
var _help_background: ColorRect
var _help_label: Label
var _status_label: Label


func _ready() -> void:
	_register_inputs()
	_create_materials()
	_create_environment()
	_create_architecture()
	_create_lighting()
	_create_player()
	_create_interface()
	_discover_assets()
	print("NOX_PROTOCOL_DESIGN_LAB_READY")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("lab_help"):
		_help_visible = not _help_visible
		_help_background.visible = _help_visible
		_help_label.visible = _help_visible
	if Input.is_action_just_pressed("lab_light"):
		_light_mode = (_light_mode + 1) % 3
		_apply_light_mode()
	if Input.is_action_just_pressed("lab_asset_previous"):
		_change_asset(-1)
	if Input.is_action_just_pressed("lab_asset_next"):
		_change_asset(1)
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
	_bind_keys("lab_light", [KEY_F2])
	_bind_keys("lab_asset_previous", [KEY_PAGEUP])
	_bind_keys("lab_asset_next", [KEY_PAGEDOWN])
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
	var architecture := Node3D.new()
	architecture.name = "ArchitectureTemoin"
	add_child(architecture)

	_add_box(
		architecture, "Sol", Vector3(12.0, 0.2, 38.0),
		Vector3(0.0, -0.1, -8.0), _materials["concrete"], true
	)
	_add_box(
		architecture, "MurGauche", Vector3(0.3, 4.0, 38.0),
		Vector3(-6.0, 2.0, -8.0), _materials["concrete_dark"], true
	)
	_add_box(
		architecture, "MurDroit", Vector3(0.3, 4.0, 38.0),
		Vector3(6.0, 2.0, -8.0), _materials["concrete_dark"], true
	)
	_add_box(
		architecture, "Fond", Vector3(12.0, 4.0, 0.3),
		Vector3(0.0, 2.0, -27.0), _materials["concrete_dark"], true
	)

	for z_position: float in [9.0, 3.0, -3.0, -9.0, -15.0, -21.0, -26.5]:
		_add_frame(architecture, z_position)

	for z_position: float in [7.0, 1.0, -5.0, -11.0, -17.0, -23.0]:
		_add_box(
			architecture, "Plafond",
			Vector3(10.8, 0.18, 2.8),
			Vector3(0.0, 4.05, z_position),
			_materials["steel_dark"]
		)
		_add_box(
			architecture, "BandeauCyan",
			Vector3(0.12, 0.02, 4.0),
			Vector3(0.0, 0.02, z_position),
			_materials["cyan"]
		)

	_create_security_door(architecture)
	_create_medical_alcove(architecture)
	_create_preview_stage(architecture)
	_create_scale_reference(architecture)


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
	var player := CharacterBody3D.new()
	player.name = "VisiteurFPS"
	player.set_script(preload("res://scripts/controleur_fps.gd"))
	player.position = Vector3(0.0, 0.02, 9.5)
	add_child(player)


func _create_interface() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "Interface"
	add_child(canvas)

	_help_background = ColorRect.new()
	_help_background.position = Vector2(16.0, 16.0)
	_help_background.size = Vector2(470.0, 190.0)
	_help_background.color = Color(0.035, 0.055, 0.075, 0.9)
	canvas.add_child(_help_background)

	_help_label = Label.new()
	_help_label.position = Vector2(30.0, 28.0)
	_help_label.text = (
		"LABORATOIRE VISUEL — F1 masque l'aide\n"
		+ "ZQSD / WASD / flèches : déplacement   Souris : regard\n"
		+ "Maj : course   Échap : libérer/capturer la souris\n"
		+ "F2 : ambiance froide / neutre / alerte\n"
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
	_asset_paths.sort()
	if not _asset_paths.is_empty():
		_asset_index = 0
		_show_asset()
	else:
		_update_status()


func _change_asset(direction: int) -> void:
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
	var resource := load(_asset_paths[_asset_index])
	if resource is not PackedScene:
		_update_status("Format chargé mais scène non instanciable")
		return
	var instance: Node = resource.instantiate()
	if instance is not Node3D:
		instance.queue_free()
		_update_status("La racine de l'asset doit être un Node3D")
		return
	_preview_instance = instance as Node3D
	_preview_instance.name = "AssetActif"
	_preview_instance.scale = Vector3.ONE * _asset_scale
	_asset_anchor.add_child(_preview_instance)
	_placeholder.visible = false
	_update_status()


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
	if not _asset_paths.is_empty() and _asset_index >= 0:
		asset_name = _asset_paths[_asset_index].get_file()
	var suffix := ""
	if not message.is_empty():
		suffix = " — %s" % message
	_status_label.text = (
		"Asset : %s | Échelle : %.2f | Ambiance : %s%s"
		% [asset_name, _asset_scale, light_names[_light_mode], suffix]
	)
