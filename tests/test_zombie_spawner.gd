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
	return failures
