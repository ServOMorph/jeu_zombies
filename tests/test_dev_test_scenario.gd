extends RefCounted

const DEV_TEST_SCENARIO := preload("res://systems/dev_test_scenario.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	if DEV_TEST_SCENARIO.has_zombies(DEV_TEST_SCENARIO.Mode.PARCOURS):
		failures.append("le scénario Parcours ne doit pas activer les zombies")
	if not DEV_TEST_SCENARIO.has_zombies(DEV_TEST_SCENARIO.Mode.SURVIE):
		failures.append("le scénario Survie doit activer les zombies")
	if DEV_TEST_SCENARIO.title(DEV_TEST_SCENARIO.Mode.PARCOURS) != "PARCOURS — sans zombies":
		failures.append("le scénario Parcours doit avoir un libellé explicite")
	return failures
