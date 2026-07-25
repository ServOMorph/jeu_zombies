extends RefCounted

const WEAPON_DEFINITION := preload("res://weapons/weapon_definition.gd")
const WEAPON_CONTROLLER := preload("res://weapons/weapon_controller.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var pistol := WEAPON_DEFINITION.new()
	pistol.weapon_name = "Test Pistolet"
	pistol.damage = 10.0
	pistol.fire_interval_seconds = 0.25
	pistol.magazine_capacity = 3
	pistol.reserve_capacity = 5
	pistol.reload_duration_seconds = 0.5
	var rifle := WEAPON_DEFINITION.new()
	rifle.weapon_name = "Test Fusil"
	rifle.magazine_capacity = 2
	rifle.reserve_capacity = 4
	var controller := WEAPON_CONTROLLER.new()
	controller.configure_slots(pistol, rifle)

	if controller.get_current_weapon_name() != "Test Pistolet":
		failures.append("le premier slot doit être l'arme active")
	if controller.get_current_ammo() != Vector2i(3, 5):
		failures.append("le chargeur et la réserve doivent être initialisés")
	if not controller.try_fire(Vector3.ZERO, Vector3.FORWARD):
		failures.append("un tir avec des munitions doit être accepté")
	if controller.get_current_ammo() != Vector2i(2, 5):
		failures.append("un tir doit consommer exactement une munition")
	if controller.try_fire(Vector3.ZERO, Vector3.FORWARD):
		failures.append("la cadence doit empêcher un tir immédiat en doublon")
	controller.tick(0.25)
	if not controller.try_fire(Vector3.ZERO, Vector3.FORWARD):
		failures.append("le tir doit redevenir possible après la cadence")

	if not controller.start_reload() or not controller.is_reloading():
		failures.append("un rechargement partiel doit démarrer")
	if controller.equip_slot(1):
		failures.append("le changement d'arme doit être bloqué pendant le rechargement")
	controller.tick(0.5)
	if controller.is_reloading() or controller.get_current_ammo() != Vector2i(3, 3):
		failures.append("le rechargement doit transférer seulement les munitions nécessaires")
	if not controller.equip_slot(1) or controller.get_current_weapon_name() != "Test Fusil":
		failures.append("le changement vers le second slot doit fonctionner")
	if controller.get_current_ammo() != Vector2i(2, 4):
		failures.append("le second slot doit conserver son propre état de munitions")
	controller.select_knife()
	if not controller.is_knife_active() or controller.get_current_weapon_name() != "Couteau":
		failures.append("le couteau doit rester sélectionnable")
	if controller.try_fire(Vector3.ZERO, Vector3.FORWARD):
		failures.append("le tir doit être impossible avec le couteau actif")
	controller.free()
	return failures
