extends SceneTree

const CRATE_PATH := "res://imports/phase6/np_z06_caisse_aleatoire.glb"
const TERMINAL_PATH := "res://imports/phase6/np_z06_terminal_extraction.glb"
const EXPECTED_ASSETS := 16


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
	var phase6_count := 0
	for asset_path: String in asset_paths:
		if asset_path.begins_with("res://imports/phase6/"):
			phase6_count += 1
	if phase6_count != EXPECTED_ASSETS:
		_fail("Découverte phase 6 incomplète : %d/%d" % [phase6_count, EXPECTED_ASSETS])
		return
	var menu := laboratory.get_node_or_null("InterfaceSelection/MenuSelection") as PanelContainer
	if menu == null or _count_phase6_buttons(menu) != EXPECTED_ASSETS:
		_fail("Entrées de menu phase 6 absentes ou incomplètes")
		return
	for asset_path: String in asset_paths:
		if not asset_path.begins_with("res://imports/phase6/"):
			continue
		var asset := laboratory.call("_instantiate_asset", asset_path) as Node3D
		if asset == null:
			_fail("Asset phase 6 incompatible : %s" % asset_path)
			return
		if asset.find_child("InteractionAnchor", true, false) == null:
			asset.free()
			_fail("InteractionAnchor absent : %s" % asset_path)
			return
		var states := asset.find_child("StateMarkers", true, false)
		if states == null or states.get_child_count() != 6:
			asset.free()
			_fail("États visuels incomplets : %s" % asset_path)
			return
		if _count_meshes(asset) < 3:
			asset.free()
			_fail("Géométrie insuffisante : %s" % asset_path)
			return
		asset.free()
	laboratory.call("_select_asset_path", CRATE_PATH)
	print("NOX_PROTOCOL_PHASE6_LAB_VALIDATION_READY assets=%d" % phase6_count)
	quit(0)


func _count_meshes(node: Node) -> int:
	var count := 1 if node is MeshInstance3D else 0
	for child: Node in node.get_children():
		count += _count_meshes(child)
	return count


func _count_phase6_buttons(node: Node) -> int:
	var count := 1 if node is Button and node.text.begins_with("np_z06_") else 0
	for child: Node in node.get_children():
		count += _count_phase6_buttons(child)
	return count


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
