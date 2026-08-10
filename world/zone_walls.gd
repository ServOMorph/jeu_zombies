class_name ZoneWalls
extends RefCounted

const WALL_PLEIN := preload("res://assets/environment/helix9/kit_structurel/np_kms_05_mur_plein.glb")
const WALL_DEMI := preload("res://assets/environment/helix9/kit_structurel/np_kms_06_demi_mur.glb")
const CORNER_EXTERIEUR := preload("res://assets/environment/helix9/kit_structurel/np_kms_08_angle_exterieur.glb")
const WALL_END := preload("res://assets/environment/helix9/kit_structurel/np_kms_09_terminaison_mur.glb")
const DOOR_FRAME := preload("res://assets/environment/helix9/kit_structurel/np_kms_13_encadrement_simple.glb")
const FLOOR_EDGE := preload("res://assets/environment/helix9/kit_structurel/np_kms_03_sol_bord.glb")
const FLOOR_CORNER := preload("res://assets/environment/helix9/kit_structurel/np_kms_02_sol_angle.glb")

const MODULE_LENGTH := 2.0
const HALF_MODULE_LENGTH := 1.0
const WALL_HEIGHT := 3.5
const WALL_THICKNESS := 0.2
const NAVIGATION_COLLISION_LAYER := 1

# Coordonnées locales à la zone (relatives à zone_root). Une baie en biais (couloirs_entrepot,
# couloirs_laboratoire) traverse le coin de la zone : le mur sud et les murs ouest/est sont
# tronqués avant le coin plutôt que refermés par un module d'angle, laissant l'ouverture au
# passage diagonal (voir roadmap_m6.md P1, calcul de l'empreinte du couloir en biais).
const WALL_RUNS: Dictionary = {
	"couloirs": [
		{"id": "nord_ouest", "start": Vector3(-9.0, 0.0, 7.0), "direction": Vector3(1.0, 0.0, 0.0), "length": 7.0, "rotation_y": 0.0},
		{"id": "nord_est", "start": Vector3(9.0, 0.0, 7.0), "direction": Vector3(-1.0, 0.0, 0.0), "length": 7.0, "rotation_y": 0.0},
		{"id": "sud", "start": Vector3(-7.0, 0.0, -7.0), "direction": Vector3(1.0, 0.0, 0.0), "length": 14.0, "rotation_y": PI},
		{"id": "ouest", "start": Vector3(-11.0, 0.0, 5.0), "direction": Vector3(0.0, 0.0, -1.0), "length": 10.0, "rotation_y": -PI / 2.0},
		{"id": "est", "start": Vector3(11.0, 0.0, 5.0), "direction": Vector3(0.0, 0.0, -1.0), "length": 10.0, "rotation_y": PI / 2.0},
	],
}

const CORNERS: Dictionary = {
	"couloirs": [
		{"id": "nord_ouest", "position": Vector3(-11.0, 0.0, 7.0), "rotation_y": 0.0},
		{"id": "nord_est", "position": Vector3(11.0, 0.0, 7.0), "rotation_y": -PI / 2.0},
	],
}

const WALL_ENDS: Dictionary = {
	"couloirs": [
		{"id": "sud_ouest", "position": Vector3(-7.0, 0.0, -7.0), "rotation_y": PI},
		{"id": "sud_est", "position": Vector3(7.0, 0.0, -7.0), "rotation_y": PI},
		{"id": "ouest_sud", "position": Vector3(-11.0, 0.0, -5.0), "rotation_y": -PI / 2.0},
		{"id": "est_sud", "position": Vector3(11.0, 0.0, -5.0), "rotation_y": PI / 2.0},
	],
}

const DOOR_FRAMES: Dictionary = {
	"couloirs": [
		{"id": "accueil_couloirs", "position": Vector3(0.0, 0.0, 7.0), "rotation_y": 0.0},
	],
}

const WALL_COLLISION_BOXES: Dictionary = {
	"couloirs": [
		{"id": "nord_ouest", "start": Vector3(-11.0, 0.0, 7.0), "end": Vector3(-2.0, 0.0, 7.0)},
		{"id": "nord_est", "start": Vector3(2.0, 0.0, 7.0), "end": Vector3(11.0, 0.0, 7.0)},
		{"id": "sud", "start": Vector3(-7.0, 0.0, -7.0), "end": Vector3(7.0, 0.0, -7.0)},
		{"id": "ouest", "start": Vector3(-11.0, 0.0, -5.0), "end": Vector3(-11.0, 0.0, 7.0)},
		{"id": "est", "start": Vector3(11.0, 0.0, -5.0), "end": Vector3(11.0, 0.0, 7.0)},
	],
}


static func build_zone_walls(zone_id: String, zone_root: Node3D) -> void:
	if not WALL_RUNS.has(zone_id):
		return

	var habillage := Node3D.new()
	habillage.name = "Habillage"
	zone_root.add_child(habillage)

	for run: Dictionary in WALL_RUNS[zone_id]:
		_place_wall_run(habillage, run)
	for corner: Dictionary in CORNERS.get(zone_id, []):
		_place_single(habillage, CORNER_EXTERIEUR, "AngleExterieur_%s" % corner["id"], corner["position"], corner["rotation_y"])
	for wall_end: Dictionary in WALL_ENDS.get(zone_id, []):
		_place_single(habillage, WALL_END, "TerminaisonMur_%s" % wall_end["id"], wall_end["position"], wall_end["rotation_y"])
	for door_frame: Dictionary in DOOR_FRAMES.get(zone_id, []):
		_place_single(habillage, DOOR_FRAME, "EncadrementSimple_%s" % door_frame["id"], door_frame["position"], door_frame["rotation_y"])
	_place_floor_borders(habillage, zone_id)

	var murs := Node3D.new()
	murs.name = "Murs"
	zone_root.add_child(murs)
	for box: Dictionary in WALL_COLLISION_BOXES.get(zone_id, []):
		_build_wall_collision(murs, box)


static func _place_wall_run(parent: Node3D, run: Dictionary) -> void:
	var start: Vector3 = run["start"]
	var direction: Vector3 = run["direction"]
	var length: float = run["length"]
	var rotation_y: float = run["rotation_y"]
	var offset := 0.0
	var index := 0
	while offset < length - 0.001:
		var remaining := length - offset
		var piece_length: float = MODULE_LENGTH if remaining >= MODULE_LENGTH - 0.001 else HALF_MODULE_LENGTH
		var scene: PackedScene = WALL_PLEIN if piece_length == MODULE_LENGTH else WALL_DEMI
		var instance := scene.instantiate() as Node3D
		instance.name = "MurPlein_%s_%d" % [run["id"], index] if piece_length == MODULE_LENGTH else "DemiMur_%s_%d" % [run["id"], index]
		instance.position = start + direction * (offset + piece_length * 0.5)
		instance.rotation.y = rotation_y
		parent.add_child(instance)
		offset += piece_length
		index += 1


static func _place_single(parent: Node3D, scene: PackedScene, node_name: String, local_position: Vector3, rotation_y: float) -> void:
	var instance := scene.instantiate() as Node3D
	instance.name = node_name
	instance.position = local_position
	instance.rotation.y = rotation_y
	parent.add_child(instance)


static func _place_floor_borders(parent: Node3D, zone_id: String) -> void:
	for run: Dictionary in WALL_RUNS.get(zone_id, []):
		var start: Vector3 = run["start"]
		var direction: Vector3 = run["direction"]
		var length: float = run["length"]
		var rotation_y: float = run["rotation_y"]
		var offset := 0.0
		var index := 0
		while offset < length - 0.001:
			var instance := FLOOR_EDGE.instantiate() as Node3D
			instance.name = "SolBord_%s_%d" % [run["id"], index]
			instance.position = start + direction * (offset + MODULE_LENGTH * 0.5)
			instance.rotation.y = rotation_y
			parent.add_child(instance)
			offset += MODULE_LENGTH
			index += 1
	for corner: Dictionary in CORNERS.get(zone_id, []):
		var instance := FLOOR_CORNER.instantiate() as Node3D
		instance.name = "SolAngle_%s" % corner["id"]
		instance.position = corner["position"]
		instance.rotation.y = corner["rotation_y"]
		parent.add_child(instance)


static func _build_wall_collision(parent: Node3D, box: Dictionary) -> void:
	var start: Vector3 = box["start"]
	var end: Vector3 = box["end"]
	var center := start.lerp(end, 0.5)
	center.y = WALL_HEIGHT * 0.5
	var horizontal_length := start.distance_to(end)
	var along_x := absf(start.x - end.x) >= absf(start.z - end.z)
	var size := Vector3(
		horizontal_length + WALL_THICKNESS if along_x else WALL_THICKNESS,
		WALL_HEIGHT,
		WALL_THICKNESS if along_x else horizontal_length + WALL_THICKNESS
	)

	var body := StaticBody3D.new()
	body.name = "Mur_%s" % box["id"]
	body.position = center
	body.collision_layer = NAVIGATION_COLLISION_LAYER
	body.collision_mask = 0
	parent.add_child(body)

	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
