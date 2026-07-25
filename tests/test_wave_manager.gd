extends RefCounted

const WAVE_DEFINITION := preload("res://data/waves/wave_definition.gd")
const WAVE_MANAGER := preload("res://systems/wave_manager.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var definition := WAVE_DEFINITION.new()
	if not WAVE_MANAGER.is_valid_wave_definition(definition):
		failures.append("une vague configurée par défaut doit être valide")
	definition.spawn_zone_id = ""
	if WAVE_MANAGER.is_valid_wave_definition(definition):
		failures.append("une vague sans zone d'apparition doit être refusée")
	definition.spawn_zone_id = "accueil"
	definition.zombie_count = 0
	if WAVE_MANAGER.is_valid_wave_definition(definition):
		failures.append("une vague sans zombie doit être refusée")
	if WAVE_MANAGER.remaining_zombie_count(3, 2) != 5:
		failures.append("le compteur doit inclure les zombies à apparaître et vivants")
	if WAVE_MANAGER.remaining_zombie_count(-1, -2) != 0:
		failures.append("le compteur ne doit jamais être négatif")
	if not WAVE_MANAGER.can_start_next_wave(WAVE_MANAGER.State.IDLE, 0, 3):
		failures.append("la première vague doit démarrer depuis l'état inactif")
	if WAVE_MANAGER.can_start_next_wave(WAVE_MANAGER.State.SPAWNING, 0, 3):
		failures.append("une vague en cours doit bloquer un nouveau démarrage")
	if WAVE_MANAGER.can_start_next_wave(WAVE_MANAGER.State.IDLE, 3, 3):
		failures.append("aucune vague ne doit démarrer après la dernière configuration")
	if not WAVE_MANAGER.is_valid_wave_index(2, 3) or WAVE_MANAGER.is_valid_wave_index(3, 3):
		failures.append("les bornes des ressources de vagues doivent être strictes")
	return failures
