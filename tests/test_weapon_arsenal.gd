extends RefCounted

const WEAPON_CONTROLLER := preload("res://weapons/weapon_controller.gd")
const STARTER_PISTOL := preload("res://weapons/data/starter_pistol.tres")
const SMG_FRELON := preload("res://weapons/data/smg_frelon.tres")
const SHOTGUN_FOUDROYEUR := preload("res://weapons/data/shotgun_foudroyeur.tres")
const RIFLE_SENTINELLE := preload("res://weapons/data/rifle_sentinelle.tres")
const SNIPER_OEIL_DE_NOX := preload("res://weapons/data/sniper_oeil_de_nox.tres")
const HEAVY_BROYEUR := preload("res://weapons/data/heavy_broyeur.tres")
const ZOMBIE_DEFINITION := preload("res://enemies/data/zombie_standard.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var arsenal := [
		STARTER_PISTOL, SMG_FRELON, SHOTGUN_FOUDROYEUR,
		RIFLE_SENTINELLE, SNIPER_OEIL_DE_NOX, HEAVY_BROYEUR,
	]

	var names := {}
	for weapon in arsenal:
		if names.has(weapon.weapon_name):
			failures.append("chaque arme doit avoir un nom distinct : doublon %s" % weapon.weapon_name)
		names[weapon.weapon_name] = true

	if SMG_FRELON.fire_interval_seconds >= RIFLE_SENTINELLE.fire_interval_seconds:
		failures.append("la mitraillette doit tirer plus vite que le fusil d'assaut")
	if SNIPER_OEIL_DE_NOX.fire_interval_seconds <= RIFLE_SENTINELLE.fire_interval_seconds:
		failures.append("le fusil de précision doit tirer plus lentement que le fusil d'assaut")
	if SNIPER_OEIL_DE_NOX.range_meters <= RIFLE_SENTINELLE.range_meters:
		failures.append("le fusil de précision doit avoir la plus longue portée")
	if SNIPER_OEIL_DE_NOX.damage < ZOMBIE_DEFINITION.max_health * 2.0:
		failures.append("le fusil de précision doit pouvoir éliminer un zombie renforcé en un tir")
	if SHOTGUN_FOUDROYEUR.pellet_count <= 1:
		failures.append("le fusil à pompe doit tirer plusieurs plombs par tir")
	if SHOTGUN_FOUDROYEUR.max_damage_per_shot <= 0.0 or SHOTGUN_FOUDROYEUR.max_damage_per_shot >= SHOTGUN_FOUDROYEUR.damage * SHOTGUN_FOUDROYEUR.pellet_count:
		failures.append("les dégâts du fusil à pompe doivent être bornés par tir en dessous du cumul de tous les plombs")
	if SHOTGUN_FOUDROYEUR.range_meters >= RIFLE_SENTINELLE.range_meters:
		failures.append("le fusil à pompe doit avoir une portée courte")
	if HEAVY_BROYEUR.magazine_capacity <= RIFLE_SENTINELLE.magazine_capacity:
		failures.append("l'arme lourde doit avoir le plus grand chargeur")
	if HEAVY_BROYEUR.reload_duration_seconds <= RIFLE_SENTINELLE.reload_duration_seconds:
		failures.append("l'arme lourde doit se recharger plus lentement que le fusil d'assaut")

	failures.append_array(_test_rapid_switch())
	failures.append_array(_test_interrupted_reload())
	failures.append_array(_test_empty_reserve())
	return failures


func _test_rapid_switch() -> Array[String]:
	var failures: Array[String] = []
	var controller := WEAPON_CONTROLLER.new()
	controller.configure_slots(RIFLE_SENTINELLE, HEAVY_BROYEUR)
	controller.try_fire(Vector3.ZERO, Vector3.FORWARD)
	if not controller.equip_slot(1):
		failures.append("le changement rapide d'arme doit réussir hors rechargement")
	if controller.get_current_ammo() != Vector2i(HEAVY_BROYEUR.magazine_capacity, HEAVY_BROYEUR.reserve_capacity):
		failures.append("changer d'arme ne doit pas altérer les munitions de l'arme visée")
	if not controller.equip_slot(0):
		failures.append("le retour immédiat à l'arme précédente doit réussir")
	if controller.get_current_ammo() != Vector2i(RIFLE_SENTINELLE.magazine_capacity - 1, RIFLE_SENTINELLE.reserve_capacity):
		failures.append("l'arme reprise doit conserver son propre état de munitions après un tir")
	controller.free()
	return failures


func _test_interrupted_reload() -> Array[String]:
	var failures: Array[String] = []
	var controller := WEAPON_CONTROLLER.new()
	controller.configure_slots(HEAVY_BROYEUR)
	for i in 5:
		controller.try_fire(Vector3.ZERO, Vector3.FORWARD)
		controller.tick(HEAVY_BROYEUR.fire_interval_seconds)
	if not controller.start_reload() or not controller.is_reloading():
		failures.append("le rechargement de l'arme lourde doit démarrer après des tirs")
	controller.disable_combat()
	if controller.is_reloading():
		failures.append("désactiver le combat doit interrompre un rechargement en cours")
	var ammo := controller.get_current_ammo()
	if ammo.x >= HEAVY_BROYEUR.magazine_capacity:
		failures.append("un rechargement interrompu ne doit pas restituer le chargeur complet")
	controller.free()
	return failures


func _test_empty_reserve() -> Array[String]:
	var failures: Array[String] = []
	var controller := WEAPON_CONTROLLER.new()
	controller.configure_slots(SHOTGUN_FOUDROYEUR)
	var dry_fire_count := [0]
	controller.dry_fire.connect(func(): dry_fire_count[0] += 1)
	var total_shots := SHOTGUN_FOUDROYEUR.magazine_capacity + SHOTGUN_FOUDROYEUR.reserve_capacity
	for i in total_shots:
		controller.try_fire(Vector3.ZERO, Vector3.FORWARD)
		controller.tick(SHOTGUN_FOUDROYEUR.fire_interval_seconds)
		if controller.get_current_ammo().x == 0 and controller.get_current_ammo().y > 0:
			controller.start_reload()
			controller.tick(SHOTGUN_FOUDROYEUR.reload_duration_seconds)
	if controller.get_current_ammo() != Vector2i.ZERO:
		failures.append("toutes les munitions doivent pouvoir être consommées jusqu'à épuisement")
	if controller.try_fire(Vector3.ZERO, Vector3.FORWARD):
		failures.append("un tir sans munition ne doit pas être accepté")
	if dry_fire_count[0] == 0:
		failures.append("un tir sans munition doit émettre un tir à vide")
	controller.free()
	return failures
