class_name HelixBlockout
extends Node3D

const ZONES: Array[Dictionary] = [
	{"id": "accueil", "name": "ACCUEIL SÉCURISÉ", "position": Vector3(0.0, 0.01, 8.0), "color": Color(0.16, 0.34, 0.48, 1.0), "decision": "Pistolet mural — 500 crédits"},
	{"id": "couloirs", "name": "COULOIRS DE CONFINEMENT", "position": Vector3(0.0, 0.01, -18.0), "color": Color(0.42, 0.3, 0.16, 1.0), "decision": "Porte nord — 750 crédits"},
	{"id": "entrepot", "name": "ENTREPÔT MÉDICAL", "position": Vector3(-28.0, 0.01, -38.0), "color": Color(0.22, 0.42, 0.3, 1.0), "decision": "Matériel médical — 1 000 crédits"},
	{"id": "laboratoire", "name": "LABORATOIRE DE SYNTHÈSE", "position": Vector3(28.0, 0.01, -38.0), "color": Color(0.42, 0.2, 0.36, 1.0), "decision": "Station d'antidote — 1 500 crédits"},
	{"id": "extraction", "name": "SALLE D'EXTRACTION", "position": Vector3(0.0, 0.01, -62.0), "color": Color(0.42, 0.16, 0.16, 1.0), "decision": "Terminal d'extraction — 2 000 crédits"},
]

const CONNECTIONS: Array[Dictionary] = [
	{"position": Vector3(0.0, 0.0, -5.0), "rotation_y": 0.0},
	{"position": Vector3(-14.0, 0.0, -28.0), "rotation_y": 0.65},
	{"position": Vector3(14.0, 0.0, -28.0), "rotation_y": -0.65},
	{"position": Vector3(-14.0, 0.0, -50.0), "rotation_y": -0.65},
	{"position": Vector3(14.0, 0.0, -50.0), "rotation_y": 0.65},
]


func _ready() -> void:
	for zone: Dictionary in ZONES:
		_create_zone(zone)
	for connection: Dictionary in CONNECTIONS:
		_create_door_frame(connection)


static func get_zone_ids() -> PackedStringArray:
	var zone_ids := PackedStringArray()
	for zone: Dictionary in ZONES:
		zone_ids.append(str(zone["id"]))
	return zone_ids


func _create_zone(zone: Dictionary) -> void:
	var zone_root := Node3D.new()
	zone_root.name = "Zone_%s" % str(zone["id"]).capitalize()
	zone_root.position = zone["position"] as Vector3
	add_child(zone_root)

	var floor := MeshInstance3D.new()
	var floor_mesh := BoxMesh.new()
	floor_mesh.size = Vector3(22.0, 0.12, 15.0)
	floor.mesh = floor_mesh
	var floor_material := StandardMaterial3D.new()
	floor_material.albedo_color = zone["color"] as Color
	floor_material.metallic = 0.2
	floor_material.roughness = 0.78
	floor.material_override = floor_material
	zone_root.add_child(floor)

	var sign := Label3D.new()
	sign.text = "%s\n%s" % [str(zone["name"]), str(zone["decision"])]
	sign.position = Vector3(0.0, 2.7, -5.5)
	sign.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sign.font_size = 52
	sign.outline_size = 6
	sign.modulate = Color(0.9, 0.95, 1.0, 1.0)
	zone_root.add_child(sign)

	for offset: Vector3 in [Vector3(-9.0, 1.2, -5.5), Vector3(9.0, 1.2, -5.5)]:
		var marker := MeshInstance3D.new()
		var marker_mesh := BoxMesh.new()
		marker_mesh.size = Vector3(0.5, 2.4, 0.5)
		marker.mesh = marker_mesh
		marker.material_override = floor_material
		marker.position = offset
		zone_root.add_child(marker)


func _create_door_frame(connection: Dictionary) -> void:
	var frame := Node3D.new()
	frame.name = "Porte_%s" % str(get_child_count())
	frame.position = connection["position"] as Vector3
	frame.rotation.y = connection["rotation_y"] as float
	add_child(frame)
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.18, 0.7, 0.82, 1.0)
	material.emission_enabled = true
	material.emission = Color(0.04, 0.22, 0.3, 1.0)
	for offset: Vector3 in [Vector3(-2.0, 1.8, 0.0), Vector3(2.0, 1.8, 0.0), Vector3(0.0, 3.5, 0.0)]:
		var segment := MeshInstance3D.new()
		var segment_mesh := BoxMesh.new()
		segment_mesh.size = Vector3(0.35, 3.6 if offset.y < 3.0 else 0.35, 0.35)
		segment.mesh = segment_mesh
		segment.material_override = material
		segment.position = offset
		frame.add_child(segment)
