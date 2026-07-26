extends SceneTree

const PISTOL_PATH := "res://imports/phase5/np_z05_pistolet.glb"
const ARMS_PATH := "res://imports/phase5/np_z05_bras_scientifique.glb"


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
	var asset_paths := laboratory.get("_asset_paths") as PackedStringArray
	if not PISTOL_PATH in asset_paths or not ARMS_PATH in asset_paths:
		_fail("Exports phase 5 absents de la découverte")
		return
	var menu := laboratory.get_node_or_null("InterfaceSelection/MenuSelection") as PanelContainer
	if menu == null or _count_phase5_buttons(menu) != 17:
		_fail("Entrées de menu phase 5 absentes ou incomplètes")
		return
	var pistol := laboratory.call("_instantiate_asset", PISTOL_PATH) as Node3D
	if pistol == null:
		_fail("Pistolet incompatible avec le laboratoire")
		return
	if pistol.find_child("WeaponVisualRoot", true, false) == null or pistol.find_child("MuzzleFlash", true, false) == null:
		pistol.free()
		_fail("Ancrages FPS absents dans le laboratoire")
		return
	var meshes := _count_meshes(pistol)
	pistol.free()
	if meshes < 5:
		_fail("Pistolet incomplet dans le laboratoire")
		return
	var arms := laboratory.call("_instantiate_asset", ARMS_PATH) as Node3D
	if arms == null or _count_meshes(arms) < 6:
		if arms != null:
			arms.free()
		_fail("Bras FPS incomplets dans le laboratoire")
		return
	arms.free()
	laboratory.call("_select_asset_path", PISTOL_PATH)
	print("NOX_PROTOCOL_PHASE5_LAB_VALIDATION_READY pistol_meshes=%d assets=%d" % [meshes, asset_paths.size()])
	quit(0)


func _count_meshes(node: Node) -> int:
	var count := 1 if node is MeshInstance3D else 0
	for child: Node in node.get_children():
		count += _count_meshes(child)
	return count


func _count_phase5_buttons(node: Node) -> int:
	var count := 1 if node is Button and node.text.begins_with("np_z05_") else 0
	for child: Node in node.get_children():
		count += _count_phase5_buttons(child)
	return count


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
