extends SceneTree

const TEST_DIRECTORY := "res://tests"
const TEST_PREFIX := "test_"
const TEST_SUFFIX := ".gd"
const TEST_FILE_ARGUMENT := "--test-file="


func _initialize() -> void:
	_run_all_tests.call_deferred()


func _run_all_tests() -> void:
	var test_files := _resolve_test_files()
	if test_files.is_empty():
		push_error("Aucun test headless trouvé.")
		quit(1)
		return

	var failures: Array[String] = []
	var executed := 0
	for test_file: String in test_files:
		executed += 1
		failures.append_array(_run_test_file(test_file))

	if not failures.is_empty():
		for failure: String in failures:
			push_error(failure)
		print("NOX_PROTOCOL_TESTS_FAILED suites=%d failures=%d" % [executed, failures.size()])
		quit(1)
		return

	print("NOX_PROTOCOL_TESTS_PASSED suites=%d" % executed)
	quit()


func _resolve_test_files() -> Array[String]:
	var requested: Array[String] = []
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with(TEST_FILE_ARGUMENT):
			requested.append(argument.trim_prefix(TEST_FILE_ARGUMENT))

	if not requested.is_empty():
		requested.sort()
		return requested

	var discovered: Array[String] = []
	for file_name: String in DirAccess.get_files_at(TEST_DIRECTORY):
		if file_name.begins_with(TEST_PREFIX) and file_name.ends_with(TEST_SUFFIX):
			discovered.append(TEST_DIRECTORY.path_join(file_name))
	discovered.sort()
	return discovered


func _run_test_file(test_file: String) -> Array[String]:
	var failures: Array[String] = []
	if not FileAccess.file_exists(test_file):
		failures.append("%s : fichier introuvable" % test_file)
		return failures

	var test_script := load(test_file) as Script
	if test_script == null:
		failures.append("%s : chargement impossible" % test_file)
		return failures
	if not test_script.can_instantiate():
		failures.append("%s : script non instanciable" % test_file)
		return failures

	var test_suite: Object = test_script.new()
	if test_suite == null:
		failures.append("%s : instanciation impossible" % test_file)
		return failures
	if not test_suite.has_method("run_tests"):
		failures.append("%s : méthode run_tests() absente" % test_file)
		return failures

	var result: Variant = test_suite.call("run_tests")
	if not result is Array:
		failures.append("%s : run_tests() doit retourner Array[String]" % test_file)
		return failures

	for failure: Variant in result:
		failures.append("%s : %s" % [test_file, str(failure)])
	return failures
