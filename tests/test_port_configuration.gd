extends RefCounted


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	if not FileAccess.file_exists("res://world/port_level.tscn"):
		failures.append("La scène du Port est absente.")
	if not FileAccess.file_exists("res://core/port_debug_notes.gd"):
		failures.append("La sauvegarde des commentaires de debug est absente.")
	if PortProgress.DEFAULT_TARGET_WAVE != 3 or PortProgress.MAX_TARGET_WAVE != 10:
		failures.append("Les bornes de progression du Port doivent être 3 et 10.")
	if PortBlockout.PLAYER_SPAWNS.size() != 10:
		failures.append("Le Port doit définir exactement dix départs joueur.")
	for player_spawn: Vector3 in PortBlockout.PLAYER_SPAWNS:
		if not PortBlockout.is_outside_warehouses(player_spawn):
			failures.append("Un départ joueur est placé dans un hangar.")
			break
	if PortBlockout.WAREHOUSES.size() != 3:
		failures.append("Le Port doit définir trois entrepôts.")
	if (PortBlockout.PORT_COORDINATES["cranes"] as Array).size() != 5:
		failures.append("Le Port doit définir cinq grues.")
	if (PortBlockout.PORT_COORDINATES["repair_boats"] as Array).size() != 2:
		failures.append("Le Port doit définir deux bateaux en réparation.")
	if (PortBlockout.PORT_COORDINATES["trucks"] as Array).size() != 3:
		failures.append("Le Port doit définir trois camions semi-remorque.")
	if (PortBlockout.PORT_COORDINATES["decorative_warehouses"] as Array).size() != 2:
		failures.append("Le Port doit définir deux entrepôts décoratifs.")
	if int(PortBalance.DEFAULTS["wave_start_count"]) != 40:
		failures.append("La première manche du Port doit contenir quarante zombies.")
	if int(PortBalance.DEFAULTS["wave_increment"]) != 5:
		failures.append("La progression doit ajouter cinq zombies par manche.")
	if int(PortBalance.DEFAULTS["weapon_1_ammo_price"]) != 100:
		failures.append("Le prix de munitions de l'arme 1 doit être configuré.")
	if not is_equal_approx(float(PortBalance.DEFAULTS["health_per_wave"]), 0.10):
		failures.append("La résistance doit augmenter de 10 % par manche.")
	if int(PortBalance.DEFAULTS["extraction_duration"]) != 90:
		failures.append("La durée par défaut de l'extraction doit être de 90 secondes.")
	return failures
