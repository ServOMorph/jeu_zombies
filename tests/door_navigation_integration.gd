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

const CLOSED_OBSERVATION_FRAMES := 240
const OPEN_OBSERVATION_FRAMES := 480
const FIRST_REGION_LIMIT_Z := -1.0
const SECOND_REGION_ENTRY_Z := -9.0


func _ready() -> void:
	var blockout := HELIX_BLOCKOUT.new()
	blockout.door_definitions = DOOR_DEFINITIONS
	blockout.wall_buy_definitions = WALL_BUY_DEFINITIONS
	blockout.mystery_box_definitions = MYSTERY_BOX_DEFINITIONS
	blockout.weapon_upgrade_station_definitions = WEAPON_UPGRADE_STATION_DEFINITIONS
	blockout.perk_station_definitions = PERK_STATION_DEFINITIONS
	blockout.quest_component_definitions = QUEST_COMPONENT_DEFINITIONS
	blockout.fabrication_station_definitions = FABRICATION_STATION_DEFINITIONS
	add_child(blockout)

	var target := Node3D.new()
	target.position = Vector3(0.0, 0.01, -18.0)
	add_child(target)

	var zombie := ZOMBIE_SCENE.instantiate() as ZombieStandard
	zombie.start_active = false
	zombie.position = Vector3(-7.0, 0.05, 8.0)
	add_child(zombie)

	for _frame in 4:
		await get_tree().physics_frame
	zombie.activate(target)
	for _frame in CLOSED_OBSERVATION_FRAMES:
		await get_tree().physics_frame
	if zombie.global_position.z < FIRST_REGION_LIMIT_Z - 0.5:
		_fail("le zombie traverse la porte fermée")
		return

	blockout.get_door("accueil_couloirs").set_open(true)
	for _frame in OPEN_OBSERVATION_FRAMES:
		await get_tree().physics_frame
		if zombie.global_position.z <= SECOND_REGION_ENTRY_Z:
			print("NOX_PROTOCOL_DOOR_NAVIGATION_PASSED")
			get_tree().quit(0)
			return
	_fail(
		"le zombie ne franchit pas la porte après son ouverture "
		+ "(position=%s, chemin=%s)" % [
			zombie.global_position,
			zombie.navigation_agent.get_current_navigation_path(),
		]
		+ " next=%s finished=%s velocity=%s" % [
			zombie.navigation_agent.get_next_path_position(),
			zombie.navigation_agent.is_navigation_finished(),
			zombie.velocity,
		]
		+ " index=%s types=%s" % [
			zombie.navigation_agent.get_current_navigation_path_index(),
			zombie.navigation_agent.get_current_navigation_result().path_types,
		]
		+ " collisions=%s" % _get_collision_debug(zombie)
	)


func _fail(reason: String) -> void:
	push_error(reason)
	get_tree().quit(1)


func _get_collision_debug(zombie: ZombieStandard) -> Array[String]:
	var collisions: Array[String] = []
	for index in zombie.get_slide_collision_count():
		var collision := zombie.get_slide_collision(index)
		collisions.append(
			"%s normal=%s" % [collision.get_collider().name, collision.get_normal()]
		)
	return collisions
