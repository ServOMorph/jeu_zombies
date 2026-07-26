extends SceneTree

const EXPORT_FILE := "res://exports/np_z04_zombie_standard.glb"


func _init() -> void:
	var file_path := ProjectSettings.globalize_path(EXPORT_FILE)
	if not FileAccess.file_exists(file_path):
		_fail("Export absent")
		return
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_file(file_path, state) != OK:
		_fail("GLB illisible")
		return
	var instance := document.generate_scene(state)
	if instance == null or instance.name != "NP_Z04_ZOM_01_Standard":
		_fail("Racine inattendue")
		return
	var meshes := _count_meshes(instance)
	if meshes < 15:
		_fail("Modèle incomplet")
		return
	if state.get_animations().size() != 8:
		_fail("Nombre de clips invalide : %d" % state.get_animations().size())
		return
	if state.get_skins().is_empty():
		_fail("Skin GLTF absent")
		return
	print("NOX_PROTOCOL_PHASE4_GLB_VALIDATION_READY meshes=%d animations=%d skins=%d" % [meshes, state.get_animations().size(), state.get_skins().size()])
	instance.free()
	quit(0)


func _count_meshes(node: Node) -> int:
	var count := 1 if node is MeshInstance3D else 0
	for child: Node in node.get_children():
		count += _count_meshes(child)
	return count


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
