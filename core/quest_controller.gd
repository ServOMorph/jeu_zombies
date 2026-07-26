extends Node

signal state_changed(previous_state: State, new_state: State)

enum State {
	SURVIVRE,
	OUVRIR_LES_ZONES,
	RECUPERER_LES_COMPOSANTS,
	FABRIQUER_ANTIDOTE,
	DEPLOYER_ANTIDOTE,
	ACTIVER_EXTRACTION,
	DEFENSE_FINALE,
	REJOINDRE_EXTRACTION,
	VICTOIRE,
}

const ORDER: Array[State] = [
	State.SURVIVRE,
	State.OUVRIR_LES_ZONES,
	State.RECUPERER_LES_COMPOSANTS,
	State.FABRIQUER_ANTIDOTE,
	State.DEPLOYER_ANTIDOTE,
	State.ACTIVER_EXTRACTION,
	State.DEFENSE_FINALE,
	State.REJOINDRE_EXTRACTION,
	State.VICTOIRE,
]

const OBJECTIVE_TEXT: Dictionary = {
	State.SURVIVRE: "Survivre aux vagues et gagner des crédits.",
	State.OUVRIR_LES_ZONES: "Ouvrir les zones verrouillées du complexe.",
	State.RECUPERER_LES_COMPOSANTS: "Récupérer les trois composants de l'antidote.",
	State.FABRIQUER_ANTIDOTE: "Fabriquer l'antidote au laboratoire.",
	State.DEPLOYER_ANTIDOTE: "Déployer l'antidote.",
	State.ACTIVER_EXTRACTION: "Activer le protocole d'extraction.",
	State.DEFENSE_FINALE: "Tenir la défense finale.",
	State.REJOINDRE_EXTRACTION: "Rejoindre le point d'extraction.",
	State.VICTOIRE: "Épidémie neutralisée.",
}

var state: State = State.SURVIVRE


func _ready() -> void:
	GameSession.session_reset.connect(_on_session_reset)


func try_advance(target_state: State) -> bool:
	if not _is_valid_next(target_state):
		return false
	var previous_state := state
	state = target_state
	_log_transition(previous_state, target_state)
	state_changed.emit(previous_state, target_state)
	return true


func get_objective_text() -> String:
	return String(OBJECTIVE_TEXT.get(state, ""))


func _is_valid_next(target_state: State) -> bool:
	var current_index := ORDER.find(state)
	var target_index := ORDER.find(target_state)
	return current_index != -1 and target_index == current_index + 1


func _log_transition(previous_state: State, new_state: State) -> void:
	if OS.is_debug_build():
		print("NOX_PROTOCOL_QUEST_TRANSITION %s -> %s" % [
			State.keys()[previous_state],
			State.keys()[new_state],
		])


func _on_session_reset() -> void:
	if state != State.SURVIVRE:
		var previous_state := state
		state = State.SURVIVRE
		_log_transition(previous_state, State.SURVIVRE)
		state_changed.emit(previous_state, State.SURVIVRE)
