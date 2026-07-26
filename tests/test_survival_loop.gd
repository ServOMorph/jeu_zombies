extends RefCounted

const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const WAVE_MANAGER := preload("res://systems/wave_manager.gd")
const STARTER_PISTOL := preload("res://weapons/data/starter_pistol.tres")
const ZOMBIE_DEFINITION := preload("res://enemies/data/zombie_standard.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var world := DEV_PLAYER_TEST.instantiate()
	var wave_manager := world.get_node_or_null("WaveManager") as WaveManager
	var zombie_spawner := world.get_node_or_null("ZombieSpawner") as ZombieSpawner
	if wave_manager == null or zombie_spawner == null:
		failures.append("la scène de survie doit contenir le gestionnaire de vagues et le spawner")
		world.free()
		return failures
	if wave_manager.wave_definitions.size() != 5:
		failures.append("la boucle de survie doit configurer cinq vagues")
	if wave_manager.intermission_seconds < 10.0:
		failures.append("la pause inter-vague doit laisser au moins dix secondes")
	if zombie_spawner.max_active_zombies != 8 or zombie_spawner.prewarm_pool_size < zombie_spawner.max_active_zombies:
		failures.append("le test de charge doit préallouer le plafond de huit zombies")
	var shots_required := 0
	for definition: WaveDefinition in wave_manager.wave_definitions:
		var shots_per_zombie := ceili(
			ZOMBIE_DEFINITION.max_health * definition.health_multiplier / STARTER_PISTOL.damage
		)
		shots_required += definition.zombie_count * shots_per_zombie
	var available_shots := STARTER_PISTOL.magazine_capacity + STARTER_PISTOL.reserve_capacity
	if available_shots < shots_required:
		failures.append("le pistolet de départ doit contenir assez de munitions pour les cinq vagues")
	wave_manager.state = WAVE_MANAGER.State.SPAWNING
	wave_manager.current_wave_number = 3
	wave_manager.stop()
	if wave_manager.state != WAVE_MANAGER.State.IDLE or wave_manager.get_remaining_zombie_count() != 0:
		failures.append("l'arrêt de survie doit vider la vague et revenir à l'état inactif")
	world.free()
	return failures
