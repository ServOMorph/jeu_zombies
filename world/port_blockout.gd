class_name PortBlockout
extends Node3D

const MAP_SIZE := 200.0
const PLAYER_SPAWNS: Array[Vector3] = [
	Vector3(-72, 0.1, -12), Vector3(-55, 0.1, 18), Vector3(-35, 0.1, 42), Vector3(-12, 0.1, 34), Vector3(14, 0.1, 34),
	Vector3(38, 0.1, 42), Vector3(67, 0.1, 16), Vector3(73, 0.1, -18), Vector3(42, 0.1, -66), Vector3(-38, 0.1, -68),
]
const WAREHOUSES: Array[Dictionary] = [
	{"id": "warehouse_1", "position": Vector3(-55, 0, -48), "entry": Vector3(-55, 0, -34), "cost_key": "door_1_price"},
	{"id": "warehouse_2", "position": Vector3(55, 0, -48), "entry": Vector3(55, 0, -34), "cost_key": "door_2_price"},
	{"id": "warehouse_3", "position": Vector3(0, 0, 58), "entry": Vector3(0, 0, 72), "cost_key": "door_3_price"},
]
const PORT_COORDINATES: Dictionary = {
	"player_spawns": PLAYER_SPAWNS,
	"warehouses": WAREHOUSES,
	"zombie_exterior": [Vector3(-84, 0.1, -80), Vector3(84, 0.1, -76), Vector3(-88, 0.1, 48), Vector3(88, 0.1, 52), Vector3(-18, 0.1, -88), Vector3(24, 0.1, 88)],
	"weapon_stations": [Vector3(-18, 0.8, 4), Vector3(-55, 0.8, -56), Vector3(55, 0.8, -56), Vector3(0, 0.8, 52)],
	"mystery_box": Vector3(-50, 0.7, -42),
	"upgrade_station": Vector3(5, 0.8, 64),
	"perk_stations": [Vector3(18, 0.7, 6), Vector3(-62, 0.7, -42), Vector3(62, 0.7, -42), Vector3(-6, 0.7, 68)],
	"container_zones": [
		{"id": "ouest", "origin": Vector3(-88, 1.5, -20), "columns": 4, "rows": 6, "spacing": Vector3(6, 0, 6)},
		{"id": "est", "origin": Vector3(64, 1.5, -20), "columns": 4, "rows": 6, "spacing": Vector3(6, 0, 6)},
		{"id": "sud", "origin": Vector3(-28, 1.5, -78), "columns": 4, "rows": 6, "spacing": Vector3(6, 0, 6)},
	],
	"cranes": [
		{"id": "centre_ouest", "position": Vector3(-30, 0, 8)},
		{"id": "centre_est", "position": Vector3(30, 0, -8)},
		{"id": "nord_ouest", "position": Vector3(-72, 0, 34)},
		{"id": "nord_est", "position": Vector3(72, 0, 34)},
		{"id": "sud_centre", "position": Vector3(0, 0, -86)},
	],
	"repair_boats": [
		{"id": "dock_ouest", "position": Vector3(-18, 0, -24)},
		{"id": "dock_est", "position": Vector3(18, 0, 24)},
	],
	"trucks": [
		{"id": "ouest_1", "position": Vector3(-56, 0, 20)},
		{"id": "ouest_2", "position": Vector3(-44, 0, 20)},
		{"id": "ouest_3", "position": Vector3(-56, 0, 40)},
	],
	"decorative_warehouses": [
		{"id": "nord_ouest", "position": Vector3(-55, 0, 70)},
		{"id": "nord_est", "position": Vector3(55, 0, 70)},
	],
	"parking": {"origin": Vector3(-12, 0, -68), "columns": 6, "rows": 5, "spacing": Vector3(5, 0, 5)},
	"extraction": Vector3.ZERO,
}

var _rng := RandomNumberGenerator.new()
var _warehouse_doors: Dictionary = {}
var _weapons: Array[WallWeaponBuy] = []
var _perks: Array[PerkStation] = []
var _mystery_box: MysteryBox
var _upgrade_station: WeaponUpgradeStation


func _ready() -> void:
	_rng.randomize()
	_create_ground()
	_create_boundaries()
	_create_port_ambience()
	for warehouse: Dictionary in WAREHOUSES:
		_create_warehouse(warehouse)
	_create_port_cover()
	_create_port_cranes()
	_create_repair_boats()
	_create_trucks()
	_create_decorative_warehouses()
	_create_parking()
	_create_stations()
	_create_navigation()


func get_random_player_spawn() -> Vector3:
	var spawns := PORT_COORDINATES["player_spawns"] as Array[Vector3]
	return spawns[_rng.randi_range(0, spawns.size() - 1)]


static func is_outside_warehouses(position_value: Vector3) -> bool:
	for warehouse: Dictionary in WAREHOUSES:
		var center := warehouse["position"] as Vector3
		if absf(position_value.x - center.x) < 16.0 and absf(position_value.z - center.z) < 14.0:
			return false
	return true


func create_zombie_spawn_points() -> void:
	for index in 6:
		_create_spawn_point("PortSpawnExterior%d" % (index + 1), [
			Vector3(-84, 0.1, -80), Vector3(84, 0.1, -76), Vector3(-88, 0.1, 48),
			Vector3(88, 0.1, 52), Vector3(-18, 0.1, -88), Vector3(24, 0.1, 88),
		][index], "port")
	for warehouse: Dictionary in WAREHOUSES:
		for index in 2:
			var point := _create_spawn_point("%sSpawn%d" % [warehouse["id"], index + 1], warehouse["position"] + Vector3(-7 + index * 14, 0.1, -4), "port")
			point.is_enabled = false
			(_warehouse_doors[warehouse["id"]] as HelixDoor).state_changed.connect(func(is_open: bool): point.is_enabled = is_open)


func apply_balance(key: String) -> void:
	match key:
		"weapon_1_price", "weapon_2_price", "weapon_3_price", "weapon_4_price":
			var index := int(key.trim_prefix("weapon_").trim_suffix("_price")) - 1
			if index >= 0 and index < _weapons.size():
				_weapons[index].price_credits = int(PortBalance.get_value(key))
		"weapon_1_ammo_price", "weapon_2_ammo_price", "weapon_3_ammo_price", "weapon_4_ammo_price":
			var ammo_index := int(key.trim_prefix("weapon_").trim_suffix("_ammo_price")) - 1
			if ammo_index >= 0 and ammo_index < _weapons.size():
				_weapons[ammo_index].ammo_price_credits = int(PortBalance.get_value(key))
		"mystery_box_price":
			if _mystery_box != null:
				_mystery_box.price_credits = int(PortBalance.get_value(key))
		"perk_price":
			for station: PerkStation in _perks:
				station.price_credits = int(PortBalance.get_value(key))
		"upgrade_price":
			if _upgrade_station != null:
				_upgrade_station.price_credits = int(PortBalance.get_value(key))
		"door_1_price", "door_2_price", "door_3_price":
			var door_index := int(key.trim_prefix("door_").trim_suffix("_price")) - 1
			var warehouse_id := "warehouse_%d" % (door_index + 1)
			if _warehouse_doors.has(warehouse_id):
				(_warehouse_doors[warehouse_id] as HelixDoor).price_credits = int(PortBalance.get_value(key))


func _create_ground() -> void:
	_create_static_box("PortFloor", Vector3(0, -0.15, 0), Vector3(MAP_SIZE, 0.3, MAP_SIZE), Color(0.055, 0.075, 0.095, 1.0))


func _create_boundaries() -> void:
	_create_static_box("NorthBoundary", Vector3(0, 3, -100), Vector3(200, 6, 1), Color(0.05, 0.07, 0.08, 1.0))
	_create_static_box("SouthBoundary", Vector3(0, 3, 100), Vector3(200, 6, 1), Color(0.05, 0.07, 0.08, 1.0))
	_create_static_box("WestBoundary", Vector3(-100, 3, 0), Vector3(1, 6, 200), Color(0.05, 0.07, 0.08, 1.0))
	_create_static_box("EastBoundary", Vector3(100, 3, 0), Vector3(1, 6, 200), Color(0.05, 0.07, 0.08, 1.0))


func _create_port_ambience() -> void:
	var cyan := Color(0.05, 0.72, 0.95, 1.0)
	var amber := Color(1.0, 0.42, 0.06, 1.0)
	var safety := Color(0.82, 0.12, 0.05, 1.0)
	_create_decor_box("DockLineNorth", Vector3(0, 0.025, -91), Vector3(176, 0.05, 0.32), cyan, true)
	_create_decor_box("DockLineSouth", Vector3(0, 0.025, 91), Vector3(176, 0.05, 0.32), cyan, true)
	_create_decor_box("DockLineWest", Vector3(-91, 0.025, 0), Vector3(0.32, 0.05, 176), cyan, true)
	_create_decor_box("DockLineEast", Vector3(91, 0.025, 0), Vector3(0.32, 0.05, 176), cyan, true)
	for warehouse: Dictionary in WAREHOUSES:
		var center := warehouse["position"] as Vector3
		_create_decor_box("Guide_%s" % warehouse["id"], center + Vector3(0, 0.03, 22), Vector3(4.5, 0.06, 20), amber, true)
		_create_decor_box("Header_%s" % warehouse["id"], center + Vector3(0, 7.2, 13.45), Vector3(13.0, 0.28, 0.12), amber, true)
	for index in 9:
		var x := -72.0 + index * 18.0
		_create_light_pole("HarborPoleNorth%d" % index, Vector3(x, 0, -88), amber)
		if index % 2 == 0:
			_create_light_pole("HarborPoleSouth%d" % index, Vector3(x, 0, 88), cyan)
	for index in 12:
		var angle := TAU * float(index) / 12.0
		var bollard_position := Vector3(cos(angle) * 89.0, 0.8, sin(angle) * 89.0)
		_create_decor_box("Bollard_%d" % index, bollard_position, Vector3(0.7, 1.6, 0.7), safety, false)


func _create_light_pole(pole_name: String, position_value: Vector3, color: Color) -> void:
	_create_decor_box("%sPost" % pole_name, position_value + Vector3(0, 4.0, 0), Vector3(0.28, 8.0, 0.28), Color(0.09, 0.12, 0.15, 1.0), false)
	_create_decor_box("%sLamp" % pole_name, position_value + Vector3(0, 7.8, 0), Vector3(1.2, 0.28, 0.7), color, true)
	var light := OmniLight3D.new()
	light.name = "%sGlow" % pole_name
	light.position = position_value + Vector3(0, 7.4, 0)
	light.light_color = color
	light.light_energy = 2.2
	light.omni_range = 15.0
	light.shadow_enabled = false
	add_child(light)


func _create_warehouse(definition: Dictionary) -> void:
	var center := definition["position"] as Vector3
	var material_color := Color(0.12, 0.18, 0.23, 1.0)
	_create_static_box("%sBack" % definition["id"], center + Vector3(0, 4, -14), Vector3(32, 8, 1), material_color)
	_create_static_box("%sFrontLeft" % definition["id"], center + Vector3(-9, 4, 14), Vector3(14, 8, 1), material_color)
	_create_static_box("%sFrontRight" % definition["id"], center + Vector3(9, 4, 14), Vector3(14, 8, 1), material_color)
	_create_static_box("%sLeft" % definition["id"], center + Vector3(-16, 4, 0), Vector3(1, 8, 28), material_color)
	_create_static_box("%sRight" % definition["id"], center + Vector3(16, 4, 0), Vector3(1, 8, 28), material_color)
	_create_static_box("%sRoof" % definition["id"], center + Vector3(0, 8, 0), Vector3(32, 0.5, 28), material_color)
	var door_definition := DoorDefinition.new()
	door_definition.display_name = "Ouvrir %s" % str(definition["id"]).replace("_", " ")
	door_definition.price_credits = int(PortBalance.get_value(str(definition["cost_key"])))
	var door := HelixDoor.new()
	door.name = "Door_%s" % definition["id"]
	door.configure(door_definition)
	door.height = 8.0
	door.position = definition["entry"] as Vector3
	add_child(door)
	_warehouse_doors[definition["id"]] = door
	var light := OmniLight3D.new()
	light.position = center + Vector3(0, 6.5, 0)
	light.light_color = Color(0.78, 0.9, 1.0, 1.0)
	light.light_energy = 3.0
	light.omni_range = 22.0
	add_child(light)


func _create_port_cover() -> void:
	var container_colors := [Color(0.035, 0.24, 0.38, 1.0), Color(0.66, 0.16, 0.08, 1.0), Color(0.72, 0.38, 0.06, 1.0), Color(0.12, 0.36, 0.28, 1.0)]
	var container_index := 1
	for zone: Dictionary in PORT_COORDINATES["container_zones"]:
		var origin := zone["origin"] as Vector3
		var spacing := zone["spacing"] as Vector3
		for row in int(zone["rows"]):
			for column in int(zone["columns"]):
				var position_value := origin + Vector3(column * spacing.x, 0, row * spacing.z)
				var container_name := "Container_%s_%d" % [str(zone["id"]), container_index]
				_create_static_box(container_name, position_value, Vector3(5.2, 3.0, 2.5), container_colors[(column + row * 2) % container_colors.size()])
				_create_decor_box("%sStripe" % container_name, position_value + Vector3(0, 0.9, -1.28), Vector3(4.6, 0.26, 0.06), Color(0.82, 0.84, 0.8, 1.0), false)
				container_index += 1


func _create_port_cranes() -> void:
	var crane_color := Color(0.82, 0.48, 0.08, 1.0)
	var cargo_color := Color(0.33, 0.27, 0.18, 1.0)
	for crane: Dictionary in PORT_COORDINATES["cranes"]:
		var crane_id := str(crane["id"])
		var position_value := crane["position"] as Vector3
		_create_static_box("CraneBase_%s" % crane_id, position_value + Vector3(0, 1.5, 0), Vector3(8, 3, 8), cargo_color)
		_create_static_box("CraneTower_%s" % crane_id, position_value + Vector3(0, 12, 0), Vector3(3, 21, 3), crane_color)
		_create_static_box("CraneBeam_%s" % crane_id, position_value + Vector3(0, 22, 0), Vector3(30, 2, 2), crane_color)
		_create_static_box("CraneCargo_%s" % crane_id, position_value + Vector3(9, 2, 7), Vector3(7, 4, 7), cargo_color)
		_create_decor_box("CraneBeacon_%s" % crane_id, position_value + Vector3(0, 23.8, 0), Vector3(0.9, 0.45, 0.9), Color(1.0, 0.08, 0.03, 1.0), true)


func _create_repair_boats() -> void:
	var hull_color := Color(0.22, 0.3, 0.34, 1.0)
	var cabin_color := Color(0.72, 0.74, 0.7, 1.0)
	var repair_color := Color(0.88, 0.45, 0.08, 1.0)
	for boat: Dictionary in PORT_COORDINATES["repair_boats"]:
		var boat_id := str(boat["id"])
		var position_value := boat["position"] as Vector3
		_create_static_box("RepairBoatHull_%s" % boat_id, position_value + Vector3(0, 1.8, 0), Vector3(12, 3.6, 28), hull_color)
		_create_static_box("RepairBoatCabin_%s" % boat_id, position_value + Vector3(0, 5, -5), Vector3(8, 3, 8), cabin_color)
		_create_static_box("RepairBoatScaffold_%s" % boat_id, position_value + Vector3(8, 5, 5), Vector3(2, 10, 12), repair_color)


func _create_trucks() -> void:
	var trailer_color := Color(0.74, 0.75, 0.72, 1.0)
	var cab_color := Color(0.18, 0.44, 0.68, 1.0)
	for truck: Dictionary in PORT_COORDINATES["trucks"]:
		var truck_id := str(truck["id"])
		var position_value := truck["position"] as Vector3
		_create_static_box("TruckTrailer_%s" % truck_id, position_value + Vector3(0, 2.6, 2), Vector3(5.2, 5.2, 16), trailer_color)
		_create_static_box("TruckCab_%s" % truck_id, position_value + Vector3(0, 2, -9), Vector3(5.2, 4, 4), cab_color)


func _create_decorative_warehouses() -> void:
	var warehouse_color := Color(0.2, 0.27, 0.3, 1.0)
	for warehouse: Dictionary in PORT_COORDINATES["decorative_warehouses"]:
		var warehouse_id := str(warehouse["id"])
		var position_value := warehouse["position"] as Vector3
		_create_static_box("DecorativeWarehouse_%s" % warehouse_id, position_value + Vector3(0, 5, 0), Vector3(28, 10, 22), warehouse_color)


func _create_parking() -> void:
	var parking := PORT_COORDINATES["parking"] as Dictionary
	var origin := parking["origin"] as Vector3
	var spacing := parking["spacing"] as Vector3
	var car_colors := [Color(0.16, 0.38, 0.62, 1.0), Color(0.72, 0.18, 0.15, 1.0), Color(0.74, 0.74, 0.7, 1.0)]
	for row in int(parking["rows"]):
		for column in int(parking["columns"]):
			var position_value := origin + Vector3(column * spacing.x, 1.1, row * spacing.z)
			_create_static_box("ParkingCar_%d_%d" % [row, column], position_value, Vector3(2.3, 2.2, 4.2), car_colors[(row + column) % car_colors.size()])


func _create_stations() -> void:
	_create_weapon("res://data/weapons/wall_buy_accueil_pistolet.tres", Vector3(-18, 0.8, 4), "weapon_1_price", "weapon_1_ammo_price")
	_create_weapon("res://data/weapons/wall_buy_couloirs_frelon.tres", Vector3(-55, 0.8, -56), "weapon_2_price", "weapon_2_ammo_price")
	_create_weapon("res://data/weapons/wall_buy_entrepot_foudroyeur.tres", Vector3(55, 0.8, -56), "weapon_3_price", "weapon_3_ammo_price")
	_create_weapon("res://data/weapons/wall_buy_laboratoire_sentinelle.tres", Vector3(0, 0.8, 52), "weapon_4_price", "weapon_4_ammo_price")
	_create_mystery_box(Vector3(-50, 0.7, -42))
	_create_upgrade_station(Vector3(5, 0.8, 64))
	_create_perk("res://data/perks/perk_constitution_renforcee.tres", Vector3(18, 0.7, 6))
	_create_perk("res://data/perks/perk_gestes_precis.tres", Vector3(-62, 0.7, -42))
	_create_perk("res://data/perks/perk_reflexes_stimules.tres", Vector3(62, 0.7, -42))
	_create_perk("res://data/perks/perk_reparation_cellulaire.tres", Vector3(-6, 0.7, 68))


func _create_weapon(path: String, position_value: Vector3, price_key: String, ammo_price_key: String) -> void:
	var definition := load(path).duplicate()
	definition.set("price_credits", int(PortBalance.get_value(price_key)))
	definition.set("ammo_price_credits", int(PortBalance.get_value(ammo_price_key)))
	var station := WallWeaponBuy.new()
	station.configure(definition)
	station.position = position_value
	add_child(station)
	_weapons.append(station)


func _create_mystery_box(position_value: Vector3) -> void:
	var definition := load("res://data/weapons/mystery_box_entrepot.tres").duplicate()
	definition.set("price_credits", int(PortBalance.get_value("mystery_box_price")))
	var box := MysteryBox.new()
	box.configure(definition)
	box.position = position_value
	add_child(box)
	_mystery_box = box


func _create_upgrade_station(position_value: Vector3) -> void:
	var definition := load("res://data/weapons/weapon_upgrade_station_laboratoire.tres").duplicate()
	definition.set("price_credits", int(PortBalance.get_value("upgrade_price")))
	var station := WeaponUpgradeStation.new()
	station.configure(definition)
	station.position = position_value
	add_child(station)
	_upgrade_station = station


func _create_perk(path: String, position_value: Vector3) -> void:
	var definition := load(path).duplicate() as PerkDefinition
	definition.price_credits = int(PortBalance.get_value("perk_price"))
	var station := PerkStation.new()
	station.configure(definition)
	station.position = position_value
	add_child(station)
	_perks.append(station)


func _create_spawn_point(point_name: String, point_position: Vector3, zone: String) -> ZombieSpawnPoint:
	var point := ZombieSpawnPoint.new()
	point.name = point_name
	point.position = point_position
	point.zone_id = zone
	add_child(point)
	return point


func _create_static_box(node_name: String, box_position: Vector3, box_size: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = box_position
	add_child(body)
	var visual := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = box_size
	visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = 0.35
	material.roughness = 0.7
	visual.material_override = material
	body.add_child(visual)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = box_size
	collision.shape = shape
	body.add_child(collision)


func _create_decor_box(node_name: String, box_position: Vector3, box_size: Vector3, color: Color, emissive: bool) -> void:
	var visual := MeshInstance3D.new()
	visual.name = node_name
	visual.position = box_position
	var mesh := BoxMesh.new()
	mesh.size = box_size
	visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = 0.55
	material.roughness = 0.45
	if emissive:
		material.emission_enabled = true
		material.emission = color
		material.emission_energy_multiplier = 4.0
	visual.material_override = material
	add_child(visual)


func _create_navigation() -> void:
	var region := NavigationRegion3D.new()
	var mesh := NavigationMesh.new()
	mesh.vertices = PackedVector3Array([Vector3(-99, 0, -99), Vector3(99, 0, -99), Vector3(99, 0, 99), Vector3(-99, 0, 99)])
	mesh.add_polygon(PackedInt32Array([0, 1, 2, 3]))
	region.navigation_mesh = mesh
	add_child(region)
