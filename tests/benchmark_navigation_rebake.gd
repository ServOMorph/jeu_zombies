extends Node3D

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
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

const REBAKE_SAMPLES := 5


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

	var load_start := Time.get_ticks_usec()
	add_child(blockout)
	var load_elapsed_ms := (Time.get_ticks_usec() - load_start) / 1000.0
	print("NOX_PROTOCOL_BENCHMARK load_ready_ms=%.3f" % load_elapsed_ms)

	var samples: Array[float] = []
	for _sample in REBAKE_SAMPLES:
		var start := Time.get_ticks_usec()
		blockout.bake_navigation()
		var elapsed_ms := (Time.get_ticks_usec() - start) / 1000.0
		samples.append(elapsed_ms)

	var total := 0.0
	for value: float in samples:
		total += value
	print(
		"NOX_PROTOCOL_BENCHMARK rebake_samples_ms=%s average_ms=%.3f"
		% [samples, total / samples.size()]
	)
	print("NOX_PROTOCOL_BENCHMARK_DONE")
	get_tree().quit(0)
