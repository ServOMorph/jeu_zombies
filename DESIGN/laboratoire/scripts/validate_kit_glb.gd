extends SceneTree

const IMPORTS_PATH := "res://imports"
const EXPECTED_MODULE_COUNT := 23


func _init() -> void:
	var directory := DirAccess.open(IMPORTS_PATH)
	if directory == null:
		_fail("Dossier d'import introuvable : %s" % IMPORTS_PATH)
		return

	var glb_files: PackedStringArray = []
	for file_name: String in directory.get_files():
		if file_name.begins_with("np_kms_") and file_name.get_extension().to_lower() == "glb":
			glb_files.append(file_name)
	glb_files.sort()
	if glb_files.size() != EXPECTED_MODULE_COUNT:
			_fail("%d GLB attendus, %d trouvés." % [EXPECTED_MODULE_COUNT, glb_files.size()])
			return

	for file_name: String in glb_files:
		var document := GLTFDocument.new()
		var state := GLTFState.new()
		var file_path := ProjectSettings.globalize_path("%s/%s" % [IMPORTS_PATH, file_name])
		var parse_error := document.append_from_file(file_path, state)
		if parse_error != OK:
			_fail("GLB illisible : %s" % file_name)
			return
		var instance := document.generate_scene(state)
		if instance is not Node3D:
			if instance != null:
				instance.queue_free()
			_fail("GLB incompatible avec le laboratoire : %s" % file_name)
			return
		instance.queue_free()

	print("NOX_PROTOCOL_KIT_GLB_IMPORT_READY count=%d" % glb_files.size())
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
