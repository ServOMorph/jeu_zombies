extends SceneTree

const EXPORTS_PATH := "res://exports"
const REQUIRED_ANIMATIONS := ["equip", "tir", "recul", "rechargement", "melee"]


func _init() -> void:
	var directory := DirAccess.open(EXPORTS_PATH)
	if directory == null:
		_fail("Dossier d'exports absent")
		return
	var files: Array[String] = []
	directory.list_dir_begin()
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension().to_lower() == "glb":
			files.append(file_name)
		file_name = directory.get_next()
	directory.list_dir_end()
	files.sort()
	if files.size() != 17:
		_fail("Nombre d'exports inattendu : %d" % files.size())
	var weapons_checked := 0
	for file: String in files:
		var document := GLTFDocument.new()
		var state := GLTFState.new()
		if document.append_from_file(ProjectSettings.globalize_path("%s/%s" % [EXPORTS_PATH, file]), state) != OK:
			_fail("GLB illisible : %s" % file)
			return
		var scene := document.generate_scene(state)
		if scene == null or _count_meshes(scene) < 2:
			_fail("Scène incomplète : %s" % file)
			return
		if file.begins_with("np_z05_") and not file in ["np_z05_bras_scientifique.glb", "np_z05_presentation_murale.glb", "np_z05_silhouette_sol.glb"]:
			if scene.find_child("WeaponVisualRoot", true, false) == null or scene.find_child("MuzzleFlash", true, false) == null:
				_fail("Ancrages absents : %s" % file)
				return
			if state.get_animations().size() != REQUIRED_ANIMATIONS.size():
				_fail("Animations absentes : %s" % file)
				return
			weapons_checked += 1
		scene.free()
	if weapons_checked != 14:
		_fail("Nombre d'armes invalide : %d" % weapons_checked)
	print("NOX_PROTOCOL_PHASE5_GLB_VALIDATION_READY weapons=%d exports=%d" % [weapons_checked, files.size()])
	quit(0)


func _count_meshes(node: Node) -> int:
	var count := 1 if node is MeshInstance3D else 0
	for child: Node in node.get_children():
		count += _count_meshes(child)
	return count


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
