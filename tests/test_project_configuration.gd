extends RefCounted


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var project_name: String = ProjectSettings.get_setting("application/config/name", "")
	if project_name != "Nox Protocol":
		failures.append(
			"application/config/name attendu « Nox Protocol », obtenu « %s »" % project_name
		)
	return failures
