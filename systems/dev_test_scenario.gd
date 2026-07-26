class_name DevTestScenario
extends RefCounted

enum Mode {
	NONE,
	PARCOURS,
	SURVIE,
}


static func has_zombies(mode: Mode) -> bool:
	return mode == Mode.SURVIE


static func title(mode: Mode) -> String:
	match mode:
		Mode.PARCOURS:
			return "PARCOURS — sans zombies"
		Mode.SURVIE:
			return "SURVIE — vagues et zombies"
		_:
			return "CHOISIR UN SCÉNARIO"
