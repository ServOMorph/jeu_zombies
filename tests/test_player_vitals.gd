extends RefCounted

const PLAYER_VITALS := preload("res://player/player_vitals.gd")


class SignalObserver:
	extends RefCounted

	var deaths := 0

	func _on_died() -> void:
		deaths += 1


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var vitals := PLAYER_VITALS.new()
	vitals.configure(100.0, 0.2, 2.0, 10.0, 100.0, 50.0, 25.0, 30.0)
	var observer := SignalObserver.new()
	vitals.died.connect(observer._on_died)

	if not vitals.apply_damage(40.0) or vitals.health != 60.0:
		failures.append("les dégâts valides doivent réduire la santé")
	if vitals.apply_damage(10.0):
		failures.append("l'invulnérabilité brève doit refuser un dégât immédiat")
	vitals.update(0.2, false)
	if not vitals.apply_damage(10.0) or vitals.health != 50.0:
		failures.append("les dégâts doivent reprendre après l'invulnérabilité")
	vitals.update(1.9, false)
	if vitals.health != 50.0:
		failures.append("la régénération ne doit pas commencer avant son délai")
	vitals.update(1.0, false)
	if vitals.health != 60.0:
		failures.append("la régénération doit restaurer la santé après son délai")

	vitals.stamina = 10.0
	vitals.update(0.2, true)
	if vitals.stamina != 0.0 or not vitals.is_exhausted or vitals.can_sprint():
		failures.append("l'endurance épuisée doit interdire la course")
	vitals.update(1.2, false)
	if vitals.is_exhausted or not vitals.can_sprint() or vitals.stamina < 30.0:
		failures.append("l'endurance doit réactiver la course après son seuil")

	vitals.update(0.2, false)
	vitals.apply_damage(1000.0)
	if not vitals.is_dead or observer.deaths != 1:
		failures.append("un dégât létal doit déclencher une unique défaite")
	if vitals.apply_damage(1.0):
		failures.append("un joueur mort ne doit plus accepter de dégâts")
	vitals.reset()
	if vitals.is_dead or vitals.health != 100.0 or vitals.stamina != 100.0:
		failures.append("la remise à zéro doit restaurer santé et endurance")
	return failures
