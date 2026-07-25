extends RefCounted

const ZOMBIE_STANDARD := preload("res://enemies/zombie_standard.gd")
const ZOMBIE_DEFINITION := preload("res://enemies/zombie_definition.gd")


class SignalObserver:
	extends RefCounted

	var deaths := 0
	var rewards := 0

	func _on_died() -> void:
		deaths += 1

	func _on_reward(_credits: int) -> void:
		rewards += 1


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	if not ZOMBIE_STANDARD.is_attack_valid(1.5, 1.6, true):
		failures.append("une cible à portée et visible doit être attaquable")
	if ZOMBIE_STANDARD.is_attack_valid(1.7, 1.6, true):
		failures.append("une cible hors portée ne doit pas être attaquable")
	if ZOMBIE_STANDARD.is_attack_valid(1.0, 1.6, false):
		failures.append("un obstacle doit empêcher l'attaque")
	if not ZOMBIE_STANDARD.should_refresh_path(0.0, 0.35):
		failures.append("un chemin doit être actualisé à échéance")
	if ZOMBIE_STANDARD.should_refresh_path(0.1, 0.35):
		failures.append("un chemin ne doit pas être recalculé avant son échéance")
	if ZOMBIE_STANDARD.resolve_vertical_velocity(0.0, false, 9.8, 0.1) >= 0.0:
		failures.append("un zombie hors sol doit être soumis à la gravité")
	if ZOMBIE_STANDARD.resolve_vertical_velocity(-1.0, true, 9.8, 0.1) != 0.0:
		failures.append("un zombie au sol ne doit pas conserver une vitesse verticale")
	var base_definition := ZOMBIE_DEFINITION.new()
	base_definition.max_health = 100.0
	var wave_zombie := ZOMBIE_STANDARD.new()
	wave_zombie.definition = base_definition
	var scaled_definition := wave_zombie.create_wave_definition(1.5)
	if scaled_definition.max_health != 150.0 or base_definition.max_health != 100.0:
		failures.append("une vague doit ajuster la santé sans modifier la définition de base")
	wave_zombie.free()

	var zombie := ZOMBIE_STANDARD.new()
	var definition := ZOMBIE_DEFINITION.new()
	definition.max_health = 40.0
	definition.credit_reward = 25
	zombie.definition = definition
	var observer := SignalObserver.new()
	zombie.died.connect(observer._on_died)
	zombie.reward_granted.connect(observer._on_reward)
	zombie.activate()
	if not zombie.receive_damage(40.0):
		failures.append("un zombie actif doit recevoir les dégâts")
	if zombie.state != ZOMBIE_STANDARD.State.DYING:
		failures.append("un dégât létal doit faire mourir le zombie")
	if observer.deaths != 1 or observer.rewards != 1:
		failures.append("la mort et la récompense doivent être émises une seule fois")
	if zombie.receive_damage(1.0):
		failures.append("un zombie mort ne doit plus recevoir de dégâts")
	if observer.deaths != 1 or observer.rewards != 1:
		failures.append("un zombie mort ne doit pas réémettre sa mort ou sa récompense")
	zombie._physics_process(definition.death_feedback_seconds + 0.1)
	if zombie.state != ZOMBIE_STANDARD.State.INACTIVE or zombie.visible:
		failures.append("un zombie mort doit être désactivé et masqué après son feedback")
	zombie.free()
	return failures
