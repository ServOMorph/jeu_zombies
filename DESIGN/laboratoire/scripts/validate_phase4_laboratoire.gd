extends SceneTree

const ZOMBIE_PATH := "res://imports/phase4/np_z04_zombie_standard.glb"


func _init() -> void:
	var scene := load("res://main.tscn") as PackedScene
	if scene == null:
		_fail("Scène principale introuvable")
		return
	var laboratory := scene.instantiate() as Node3D
	if laboratory == null:
		_fail("Scène principale incompatible")
		return
	root.add_child(laboratory)
	call_deferred("_validate", laboratory)


func _validate(laboratory: Node3D) -> void:
	var menu := laboratory.get_node_or_null("InterfaceSelection/MenuSelection") as PanelContainer
	if menu == null or _count_buttons(menu) < 30:
		_fail("Entrée de menu phase 4 absente")
		return
	var asset_paths := laboratory.get("_asset_paths") as PackedStringArray
	if not ZOMBIE_PATH in asset_paths:
		_fail("Export phase 4 absent de la découverte : %s" % asset_paths)
		return
	var direct_instance := laboratory.call("_instantiate_asset", ZOMBIE_PATH) as Node3D
	if direct_instance == null:
		_fail("Export phase 4 incompatible avec le laboratoire")
		return
	var meshes := _count_meshes(direct_instance)
	if meshes < 15:
		direct_instance.free()
		_fail("Zombie incomplet dans le laboratoire")
		return
	direct_instance.free()
	laboratory.call("_select_asset_path", ZOMBIE_PATH)
	var player := laboratory.find_child("VisiteurFPS", true, false) as CharacterBody3D
	if player == null or not player.position.is_equal_approx(Vector3(0.0, 0.02, -8.0)):
		_fail("Téléportation de prévisualisation invalide")
		return
	print("NOX_PROTOCOL_PHASE4_LAB_VALIDATION_READY meshes=%d" % meshes)
	quit(0)


func _count_meshes(node: Node) -> int:
	var count := 1 if node is MeshInstance3D else 0
	for child: Node in node.get_children():
		count += _count_meshes(child)
	return count


func _count_buttons(node: Node) -> int:
	var count := 1 if node is Button else 0
	for child: Node in node.get_children():
		count += _count_buttons(child)
	return count


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
