extends SceneTree

const IMPORTS_PATH := "res://imports"
const EXPECTED_MODULE_COUNT := 23


func _init() -> void:
	var output_path := ProjectSettings.globalize_path("res://../kit_modulaire/exports").simplify_path()
	var output_error := DirAccess.make_dir_recursive_absolute(output_path)
	if output_error != OK:
		_fail("Création du dossier d'export impossible : %s" % output_path)
		return

	var directory := DirAccess.open(IMPORTS_PATH)
	if directory == null:
		_fail("Dossier source introuvable : %s" % IMPORTS_PATH)
		return

	var source_files: PackedStringArray = []
	for file_name: String in directory.get_files():
		if file_name.begins_with("np_kms_") and file_name.get_extension().to_lower() == "tscn":
			source_files.append(file_name)
	source_files.sort()
	if source_files.size() != EXPECTED_MODULE_COUNT:
		_fail("%d prototypes attendus, %d trouvés." % [EXPECTED_MODULE_COUNT, source_files.size()])
		return

	for source_file: String in source_files:
		var resource := load("%s/%s" % [IMPORTS_PATH, source_file])
		if resource is not PackedScene:
			_fail("Scène non chargeable : %s" % source_file)
			return
		var instance := (resource as PackedScene).instantiate()
		var document := GLTFDocument.new()
		var state := GLTFState.new()
		var append_error := document.append_from_scene(instance, state)
		if append_error != OK:
			instance.queue_free()
			_fail("Export GLB impossible : %s" % source_file)
			return
		var output_file := output_path.path_join("%s.glb" % source_file.get_basename())
		var write_error := document.write_to_filesystem(state, output_file)
		instance.queue_free()
		if write_error != OK:
			_fail("Écriture GLB impossible : %s" % output_file)
			return

	print("NOX_PROTOCOL_KIT_GLB_EXPORT_READY count=%d" % source_files.size())
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
