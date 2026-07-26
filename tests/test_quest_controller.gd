extends RefCounted

const QUEST_CONTROLLER_SCRIPT := preload("res://core/quest_controller.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var quest := QUEST_CONTROLLER_SCRIPT.new()

	if quest.state != quest.State.SURVIVRE:
		failures.append("l'état initial doit être SURVIVRE")
	if quest.get_objective_text() != "Survivre aux vagues et gagner des crédits.":
		failures.append("l'objectif initial doit décrire la survie")

	var transitions_seen: Array[int] = []
	quest.state_changed.connect(func(previous_state: int, new_state: int) -> void:
		transitions_seen.append(new_state)
	)

	if quest.try_advance(quest.State.RECUPERER_LES_COMPOSANTS):
		failures.append("sauter une étape doit être refusé sans modifier la progression")
	if quest.state != quest.State.SURVIVRE:
		failures.append("un refus de transition ne doit pas modifier l'état")
	if quest.try_advance(quest.State.SURVIVRE):
		failures.append("rester sur l'état courant n'est pas une transition valide")

	var ordered_targets: Array[int] = [
		quest.State.OUVRIR_LES_ZONES,
		quest.State.RECUPERER_LES_COMPOSANTS,
		quest.State.FABRIQUER_ANTIDOTE,
		quest.State.DEPLOYER_ANTIDOTE,
		quest.State.ACTIVER_EXTRACTION,
		quest.State.DEFENSE_FINALE,
		quest.State.REJOINDRE_EXTRACTION,
		quest.State.VICTOIRE,
	]
	for target_state: int in ordered_targets:
		if not quest.try_advance(target_state):
			failures.append("la transition séquentielle vers %s doit être acceptée" % quest.State.keys()[target_state])
		if quest.state != target_state:
			failures.append("l'état courant doit refléter la dernière transition acceptée")

	if transitions_seen != ordered_targets:
		failures.append("le signal state_changed doit être émis exactement une fois par transition acceptée, dans l'ordre")

	if quest.try_advance(quest.State.VICTOIRE):
		failures.append("aucune transition n'est possible après VICTOIRE")
	if quest.try_advance(quest.State.SURVIVRE):
		failures.append("revenir en arrière n'est pas une transition valide")

	if quest.get_objective_text() != "Épidémie neutralisée.":
		failures.append("l'objectif final doit annoncer la victoire")

	quest._on_session_reset()
	if quest.state != quest.State.SURVIVRE:
		failures.append("la remise à zéro de session doit ramener la quête à SURVIVRE")
	if transitions_seen.size() != ordered_targets.size() + 1 or transitions_seen[-1] != quest.State.SURVIVRE:
		failures.append("la remise à zéro doit émettre une transition unique vers SURVIVRE")

	quest.free()
	return failures
