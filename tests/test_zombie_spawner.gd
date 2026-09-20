extends RefCounted

const ZOMBIE_SPAWNER := preload("res://enemies/zombie_spawner.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	if not ZOMBIE_SPAWNER.is_outside_player_exclusion(6.0, 6.0):
		failures.append("la limite d'exclusion doit autoriser le point exactement à sa frontière")
	if ZOMBIE_SPAWNER.is_outside_player_exclusion(5.99, 6.0):
		failures.append("un point dans le champ proche du joueur doit être refusé")
	if not ZOMBIE_SPAWNER.can_spawn(3, 4):
		failures.append("un plafond non atteint doit autoriser une apparition")
	if ZOMBIE_SPAWNER.can_spawn(4, 4):
		failures.append("un plafond atteint doit bloquer une apparition")

	var primary_index := ZOMBIE_SPAWNER.select_candidate_index(
		[8.0, 10.0],
		[false, false],
		6.0,
	)
	if primary_index != -1:
		failures.append("un point sans chemin navigable doit être refusé")
	var fallback_index := ZOMBIE_SPAWNER.select_candidate_index(
		[3.0, 9.0],
		[true, true],
		6.0,
	)
	if fallback_index != 1:
		failures.append("le repli doit ignorer le point proche et retenir le premier point navigable valide")
	var nearest_index := ZOMBIE_SPAWNER.select_nearest_candidate_index(
		[14.0, 8.0, 10.0],
		[true, true, true],
		6.0,
	)
	if nearest_index != 1:
		failures.append("le Port doit choisir le point valide le plus proche du joueur")
	var nearest_indices := ZOMBIE_SPAWNER.select_nearest_candidate_indices(
		[12.0, 7.0, 18.0, 9.0, 14.0, 8.0, 5.0],
		[true, true, true, true, true, true, true],
		6.0,
		5,
	)
	if nearest_indices != [1, 5, 3, 0, 4]:
		failures.append("le Port doit retenir les cinq points valides les plus proches du joueur")
	return failures
