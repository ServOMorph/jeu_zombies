extends Node3D

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const ZOMBIE_SCENE := preload("res://enemies/zombie_standard.tscn")
const DOOR_DEFINITIONS: Array[Resource] = [
	preload("res://data/doors/accueil_couloirs.tres"),
	preload("res://data/doors/couloirs_entrepot.tres"),
	preload("res://data/doors/couloirs_laboratoire.tres"),
	preload("res://data/doors/entrepot_extraction.tres"),
	preload("res://data/doors/laboratoire_extraction.tres"),
]
const WALL_BUY_DEFINITIONS: Array[Resource] = [
	preload("res://data/weapons/wall_buy_accueil_pistolet.tres"),
	preload("res://data/weapons/wall_buy_couloirs_frelon.tres"),
	preload("res://data/weapons/wall_buy_entrepot_foudroyeur.tres"),
	preload("res://data/weapons/wall_buy_laboratoire_sentinelle.tres"),
	preload("res://data/weapons/wall_buy_extraction_oeil_de_nox.tres"),
	preload("res://data/weapons/wall_buy_extraction_broyeur.tres"),
]
const MYSTERY_BOX_DEFINITIONS: Array[Resource] = [
	preload("res://data/weapons/mystery_box_entrepot.tres"),
]
const WEAPON_UPGRADE_STATION_DEFINITIONS: Array[Resource] = [
	preload("res://data/weapons/weapon_upgrade_station_laboratoire.tres"),
]
const PERK_STATION_DEFINITIONS: Array[Resource] = [
	preload("res://data/perks/perk_constitution_renforcee.tres"),
	preload("res://data/perks/perk_gestes_precis.tres"),
	preload("res://data/perks/perk_reflexes_stimules.tres"),
	preload("res://data/perks/perk_reparation_cellulaire.tres"),
]
const QUEST_COMPONENT_DEFINITIONS: Array[Resource] = [
	preload("res://data/quest/component_couloirs.tres"),
	preload("res://data/quest/component_entrepot.tres"),
	preload("res://data/quest/component_extraction.tres"),
]
const FABRICATION_STATION_DEFINITIONS: Array[Resource] = [
	preload("res://data/quest/fabrication_station_laboratoire.tres"),
]
const DEPLOYMENT_POINT_DEFINITIONS: Array[Resource] = [
	preload("res://data/quest/deployment_point_laboratoire.tres"),
]
const EXTRACTION_TERMINAL_DEFINITIONS: Array[Resource] = [
	preload("res://data/quest/extraction_terminal_salle.tres"),
]

const SPAWN_POSITION := Vector3(-7.0, 0.05, 8.0)
const APPROACH_LIMIT_METERS := 2.0
const OBSERVATION_FRAMES := 900

# Scenarios de blocage constates le 2026-08-08 : mobilier absent de la navmesh et
# joueur place dans un passage inter-zones.
const SCENARIOS: Array[Dictionary] = [
	{
		"label": "cible derriere le rack mural des Couloirs",
		"position": Vector3(0.0, 0.01, -13.0),
	},
	{
		"label": "cible au milieu du passage accueil_couloirs",
		"position": Vector3(0.0, 0.01, -5.0),
	},
]


func _ready() -> void:
	var blockout := HELIX_BLOCKOUT.new()
	blockout.door_definitions = DOOR_DEFINITIONS
	blockout.wall_buy_definitions = WALL_BUY_DEFINITIONS
	blockout.mystery_box_definitions = MYSTERY_BOX_DEFINITIONS
	blockout.weapon_upgrade_station_definitions = WEAPON_UPGRADE_STATION_DEFINITIONS
	blockout.perk_station_definitions = PERK_STATION_DEFINITIONS
	blockout.quest_component_definitions = QUEST_COMPONENT_DEFINITIONS
	blockout.fabrication_station_definitions = FABRICATION_STATION_DEFINITIONS
	blockout.deployment_point_definitions = DEPLOYMENT_POINT_DEFINITIONS
	blockout.extraction_terminal_definitions = EXTRACTION_TERMINAL_DEFINITIONS
	add_child(blockout)
	for door_id in blockout.get_door_ids():
		blockout.get_door(door_id).set_open(true)
	for _frame in 8:
		await get_tree().physics_frame

	for scenario: Dictionary in SCENARIOS:
		var reached := await _run_chase(
			scenario["position"] as Vector3,
			str(scenario["label"]),
		)
		if not reached:
			return

	print("NOX_PROTOCOL_ZOMBIE_NAVIGATION_PASSED")
	get_tree().quit(0)


func _run_chase(target_position: Vector3, label: String) -> bool:
	var target := Node3D.new()
	target.position = target_position
	add_child(target)
	var zombie := ZOMBIE_SCENE.instantiate() as ZombieStandard
	zombie.start_active = false
	zombie.position = SPAWN_POSITION
	add_child(zombie)
	for _frame in 4:
		await get_tree().physics_frame
	zombie.activate(target)

	var closest_distance := zombie.global_position.distance_to(target_position)
	for _frame in OBSERVATION_FRAMES:
		await get_tree().physics_frame
		var distance := zombie.global_position.distance_to(target_position)
		closest_distance = minf(closest_distance, distance)
		if distance <= APPROACH_LIMIT_METERS:
			zombie.queue_free()
			target.queue_free()
			return true

	_fail(
		"le zombie n'atteint pas sa cible (%s) : distance minimale=%.2f m, "
		% [label, closest_distance]
		+ "position=%s, vitesse=%.2f, navigation_finished=%s, collisions=%s"
		% [
			zombie.global_position,
			zombie.velocity.length(),
			zombie.navigation_agent.is_navigation_finished(),
			_get_collision_debug(zombie),
		]
	)
	return false


func _fail(reason: String) -> void:
	push_error(reason)
	get_tree().quit(1)


func _get_collision_debug(zombie: ZombieStandard) -> Array[String]:
	var collisions: Array[String] = []
	for index in zombie.get_slide_collision_count():
		collisions.append(str(zombie.get_slide_collision(index).get_collider().name))
	return collisions
