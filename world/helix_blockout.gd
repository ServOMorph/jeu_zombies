class_name HelixBlockout
extends Node3D

const ZONES: Array[Dictionary] = [
	{"id": "accueil", "name": "ACCUEIL SÉCURISÉ", "position": Vector3(0.0, 0.01, 7.5), "floor_size": Vector3(20.0, 0.12, 17.0), "color": Color(0.16, 0.34, 0.48, 1.0), "decision": "Pistolet mural — 500 crédits"},
	{"id": "couloirs", "name": "COULOIRS DE CONFINEMENT", "position": Vector3(0.0, 0.01, -16.0), "floor_size": Vector3(22.0, 0.12, 14.0), "color": Color(0.42, 0.3, 0.16, 1.0), "decision": "Porte nord — 750 crédits"},
	{"id": "entrepot", "name": "ENTREPÔT MÉDICAL", "position": Vector3(-31.0, 0.01, -39.5), "floor_size": Vector3(18.0, 0.12, 15.0), "color": Color(0.22, 0.42, 0.3, 1.0), "decision": "Matériel médical — 1 000 crédits"},
	{"id": "laboratoire", "name": "LABORATOIRE DE SYNTHÈSE", "position": Vector3(31.0, 0.01, -39.5), "floor_size": Vector3(18.0, 0.12, 15.0), "color": Color(0.42, 0.2, 0.36, 1.0), "decision": "Station d'antidote — 1 500 crédits"},
	{"id": "extraction", "name": "SALLE D'EXTRACTION", "position": Vector3(0.0, 0.01, -63.0), "floor_size": Vector3(22.0, 0.12, 16.0), "color": Color(0.42, 0.16, 0.16, 1.0), "decision": "Terminal d'extraction — 2 000 crédits"},
]

static var CONNECTIONS: Array[Dictionary] = [
	{"id": "accueil_couloirs", "position": Vector3(0.0, 0.0, -5.0), "rotation_y": 0.0, "start": Vector3(0.0, 0.0, -0.5), "end": Vector3(0.0, 0.0, -9.5), "zones": PackedStringArray(["accueil", "couloirs"])},
	{"id": "couloirs_entrepot", "position": Vector3(-16.0, 0.0, -27.5), "rotation_y": -2.23, "start": Vector3(-9.5, 0.0, -22.5), "end": Vector3(-22.5, 0.0, -32.5), "zones": PackedStringArray(["couloirs", "entrepot"])},
	{"id": "couloirs_laboratoire", "position": Vector3(16.0, 0.0, -27.5), "rotation_y": 2.23, "start": Vector3(9.5, 0.0, -22.5), "end": Vector3(22.5, 0.0, -32.5), "zones": PackedStringArray(["couloirs", "laboratoire"])},
	{"id": "entrepot_extraction", "position": Vector3(-14.5, 0.0, -50.0), "rotation_y": 2.31, "start": Vector3(-22.5, 0.0, -44.5), "end": Vector3(-6.5, 0.0, -55.5), "zones": PackedStringArray(["entrepot", "extraction"])},
	{"id": "laboratoire_extraction", "position": Vector3(14.5, 0.0, -50.0), "rotation_y": -2.31, "start": Vector3(22.5, 0.0, -44.5), "end": Vector3(6.5, 0.0, -55.5), "zones": PackedStringArray(["laboratoire", "extraction"])},
]

static var NAVIGATION_AREAS: Array[PackedVector3Array] = [
	PackedVector3Array([Vector3(-10.0, 0.0, -1.0), Vector3(10.0, 0.0, -1.0), Vector3(10.0, 0.0, 16.0), Vector3(-10.0, 0.0, 16.0)]),
	PackedVector3Array([Vector3(-11.0, 0.0, -9.0), Vector3(11.0, 0.0, -9.0), Vector3(11.0, 0.0, -23.0), Vector3(-11.0, 0.0, -23.0)]),
	PackedVector3Array([Vector3(-40.0, 0.0, -32.0), Vector3(-22.0, 0.0, -32.0), Vector3(-22.0, 0.0, -47.0), Vector3(-40.0, 0.0, -47.0)]),
	PackedVector3Array([Vector3(22.0, 0.0, -32.0), Vector3(40.0, 0.0, -32.0), Vector3(40.0, 0.0, -47.0), Vector3(22.0, 0.0, -47.0)]),
	PackedVector3Array([Vector3(-11.0, 0.0, -55.0), Vector3(11.0, 0.0, -55.0), Vector3(11.0, 0.0, -71.0), Vector3(-11.0, 0.0, -71.0)]),
]

const WALL_BUYS: Array[Dictionary] = [
	{"id": "accueil_pistolet", "zone": "accueil", "position": Vector3(0.0, 1.1, 4.0)},
	{"id": "couloirs_frelon", "zone": "couloirs", "position": Vector3(0.0, 1.1, 4.0)},
	{"id": "entrepot_foudroyeur", "zone": "entrepot", "position": Vector3(0.0, 1.1, 4.0)},
	{"id": "laboratoire_sentinelle", "zone": "laboratoire", "position": Vector3(0.0, 1.1, 4.0)},
	{"id": "extraction_oeil_de_nox", "zone": "extraction", "position": Vector3(-5.0, 1.1, 4.0)},
	{"id": "extraction_broyeur", "zone": "extraction", "position": Vector3(5.0, 1.1, 4.0)},
]

const MYSTERY_BOXES: Array[Dictionary] = [
	{"id": "entrepot_caisse", "zone": "entrepot", "position": Vector3(-5.0, 1.1, -4.0)},
]

var _doors: Dictionary = {}
var _wall_buys: Dictionary = {}
var _mystery_boxes: Dictionary = {}
var _zone_roots: Dictionary = {}

@export var door_definitions: Array[Resource] = []
@export var wall_buy_definitions: Array[Resource] = []
@export var mystery_box_definitions: Array[Resource] = []


func _ready() -> void:
	for zone: Dictionary in ZONES:
		_create_zone(zone)
	for connection: Dictionary in CONNECTIONS:
		_create_door(connection)
	for wall_buy: Dictionary in WALL_BUYS:
		_create_wall_buy(wall_buy)
	for mystery_box: Dictionary in MYSTERY_BOXES:
		_create_mystery_box(mystery_box)
	_create_navigation_regions()


static func get_zone_ids() -> PackedStringArray:
	var zone_ids := PackedStringArray()
	for zone: Dictionary in ZONES:
		zone_ids.append(str(zone["id"]))
	return zone_ids


static func get_door_ids() -> PackedStringArray:
	var door_ids := PackedStringArray()
	for connection: Dictionary in CONNECTIONS:
		door_ids.append(str(connection["id"]))
	return door_ids


static func get_wall_buy_ids() -> PackedStringArray:
	var buy_ids := PackedStringArray()
	for wall_buy: Dictionary in WALL_BUYS:
		buy_ids.append(str(wall_buy["id"]))
	return buy_ids


static func get_mystery_box_ids() -> PackedStringArray:
	var box_ids := PackedStringArray()
	for mystery_box: Dictionary in MYSTERY_BOXES:
		box_ids.append(str(mystery_box["id"]))
	return box_ids


func set_all_doors_open(should_open: bool) -> void:
	for door: HelixDoor in _doors.values():
		door.set_open(should_open)


func are_all_doors_open() -> bool:
	for door: HelixDoor in _doors.values():
		if not door.is_open:
			return false
	return true


func get_door(door_id: String) -> HelixDoor:
	return _doors.get(door_id) as HelixDoor


func get_wall_buy(buy_id: String) -> WallWeaponBuy:
	return _wall_buys.get(buy_id) as WallWeaponBuy


func get_mystery_box(box_id: String) -> MysteryBox:
	return _mystery_boxes.get(box_id) as MysteryBox


func can_navigate_between(start_zone_id: String, end_zone_id: String) -> bool:
	if start_zone_id == end_zone_id:
		return true
	var reachable := {start_zone_id: true}
	var pending := PackedStringArray([start_zone_id])
	while not pending.is_empty():
		var zone_id := pending[0]
		pending.remove_at(0)
		for connection: Dictionary in CONNECTIONS:
			var door := get_door(str(connection["id"]))
			if door == null or not door.is_open:
				continue
			var zones := connection["zones"] as PackedStringArray
			if not zones.has(zone_id):
				continue
			var next_zone := zones[1] if zones[0] == zone_id else zones[0]
			if next_zone == end_zone_id:
				return true
			if not reachable.has(next_zone):
				reachable[next_zone] = true
				pending.append(next_zone)
	return false


func _create_zone(zone: Dictionary) -> void:
	var zone_root := Node3D.new()
	zone_root.name = "Zone_%s" % str(zone["id"]).capitalize()
	zone_root.position = zone["position"] as Vector3
	add_child(zone_root)
	_zone_roots[str(zone["id"])] = zone_root

	var floor := StaticBody3D.new()
	floor.name = "Floor"
	zone_root.add_child(floor)
	var floor_visual := MeshInstance3D.new()
	var floor_mesh := BoxMesh.new()
	floor_mesh.size = zone["floor_size"] as Vector3
	floor_visual.mesh = floor_mesh
	var floor_material := StandardMaterial3D.new()
	floor_material.albedo_color = zone["color"] as Color
	floor_material.metallic = 0.2
	floor_material.roughness = 0.78
	floor_visual.material_override = floor_material
	floor.add_child(floor_visual)
	var floor_collision := CollisionShape3D.new()
	floor_collision.name = "CollisionShape3D"
	var floor_shape := BoxShape3D.new()
	floor_shape.size = zone["floor_size"] as Vector3
	floor_collision.shape = floor_shape
	floor.add_child(floor_collision)

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


func _create_door(connection: Dictionary) -> void:
	var door_id := str(connection["id"])
	var definition := _find_door_definition(door_id)
	if definition == null:
		push_error("Définition de porte manquante : %s" % door_id)
		return
	var door := HelixDoor.new()
	door.name = "Porte_%s" % door_id
	door.configure(definition)
	door.position = connection["position"] as Vector3
	door.rotation.y = connection["rotation_y"] as float
	add_child(door)
	door.configure_navigation_link(connection["start"] as Vector3, connection["end"] as Vector3)
	door.state_changed.connect(_on_door_state_changed)
	_doors[door_id] = door
	_create_connection_floor(connection)
	var frame := Node3D.new()
	frame.name = "Cadre"
	door.add_child(frame)
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


func _find_door_definition(door_id: String) -> Resource:
	for definition: Resource in door_definitions:
		if definition != null and str(definition.get("door_id")) == door_id:
			return definition
	return null


func _create_wall_buy(wall_buy: Dictionary) -> void:
	var buy_id := str(wall_buy["id"])
	var definition := _find_wall_buy_definition(buy_id)
	if definition == null:
		push_error("Définition d'achat mural manquante : %s" % buy_id)
		return
	var zone_root := _zone_roots.get(str(wall_buy["zone"])) as Node3D
	if zone_root == null:
		push_error("Zone introuvable pour l'achat mural : %s" % buy_id)
		return
	var wall_weapon_buy := WallWeaponBuy.new()
	wall_weapon_buy.name = "AchatMural_%s" % buy_id
	wall_weapon_buy.configure(definition)
	wall_weapon_buy.position = wall_buy["position"] as Vector3
	zone_root.add_child(wall_weapon_buy)
	_wall_buys[buy_id] = wall_weapon_buy


func _find_wall_buy_definition(buy_id: String) -> Resource:
	for definition: Resource in wall_buy_definitions:
		if definition != null and str(definition.get("buy_id")) == buy_id:
			return definition
	return null


func _create_mystery_box(mystery_box: Dictionary) -> void:
	var box_id := str(mystery_box["id"])
	var definition := _find_mystery_box_definition(box_id)
	if definition == null:
		push_error("Définition de caisse aléatoire manquante : %s" % box_id)
		return
	var zone_root := _zone_roots.get(str(mystery_box["zone"])) as Node3D
	if zone_root == null:
		push_error("Zone introuvable pour la caisse aléatoire : %s" % box_id)
		return
	var box := MysteryBox.new()
	box.name = "CaisseAleatoire_%s" % box_id
	box.configure(definition)
	box.position = mystery_box["position"] as Vector3
	zone_root.add_child(box)
	_mystery_boxes[box_id] = box


func _find_mystery_box_definition(box_id: String) -> Resource:
	for definition: Resource in mystery_box_definitions:
		if definition != null and str(definition.get("box_id")) == box_id:
			return definition
	return null


func _create_connection_floor(connection: Dictionary) -> void:
	var start_point := connection["start"] as Vector3
	var end_point := connection["end"] as Vector3
	var direction := end_point - start_point
	var passage := StaticBody3D.new()
	passage.name = "Passage_%s" % str(connection["id"])
	passage.position = start_point.lerp(end_point, 0.5)
	passage.position.y = 0.01
	passage.rotation.y = atan2(direction.x, direction.z)
	add_child(passage)
	var mesh := BoxMesh.new()
	mesh.size = Vector3(4.0, 0.12, direction.length())
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.12, 0.16, 0.2, 1.0)
	material.metallic = 0.55
	material.roughness = 0.48
	visual.material_override = material
	passage.add_child(visual)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = mesh.size
	collision.shape = shape
	passage.add_child(collision)


func _create_navigation_regions() -> void:
	for index in NAVIGATION_AREAS.size():
		var region := NavigationRegion3D.new()
		region.name = "NavigationRegion_%s" % str(ZONES[index]["id"])
		var mesh := NavigationMesh.new()
		mesh.vertices = NAVIGATION_AREAS[index]
		mesh.add_polygon(PackedInt32Array([0, 3, 2, 1]))
		region.navigation_mesh = mesh
		add_child(region)
		NavigationServer3D.region_set_enabled(region.get_region_rid(), true)
		NavigationServer3D.region_set_map(region.get_region_rid(), get_world_3d().navigation_map)
		NavigationServer3D.region_set_navigation_mesh(region.get_region_rid(), mesh)


func _on_door_state_changed(_is_open: bool) -> void:
	get_tree().call_group("zombies", "request_navigation_repath")
