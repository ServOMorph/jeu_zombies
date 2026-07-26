extends SceneTree

var laboratory: Node3D


func _init() -> void:
	var scene := load("res://main.tscn") as PackedScene
	if scene == null:
		_fail("Scène principale introuvable")
		return
	laboratory = scene.instantiate() as Node3D
	if laboratory == null:
		_fail("Scène principale incompatible")
		return
	root.add_child(laboratory)
	call_deferred("_validate")


func _validate() -> void:
	var root_vignettes := laboratory.get_node_or_null("VignettesValidation") as Node3D
	if root_vignettes == null or root_vignettes.get_child_count() != 15:
		_fail("Nombre de vignettes invalide")
		return
	var menu := laboratory.get_node_or_null("InterfaceSelection/MenuSelection") as PanelContainer
	if menu == null or _count_buttons(menu) != 29:
		_fail("Menu de sélection invalide")
		return
	for vignette_name: String in [
		"VignettePhase3Accueil",
		"VignettePhase3Confinement",
		"VignettePhase3Medical",
		"VignettePhase3Synthese",
		"VignettePhase3Extraction",
		"ZoneCompleteAccueil",
		"ZoneCompleteConfinement",
		"ZoneCompleteEntrepotMedical",
		"ZoneCompleteSynthese",
		"ZoneCompleteExtraction",
	]:
		var vignette := root_vignettes.get_node_or_null(vignette_name) as Node3D
		if vignette == null or _count_meshes(vignette) == 0:
			_fail("Vignette invalide : %s" % vignette_name)
			return
	for index: int in range(10, 15):
		laboratory.call("_select_validation_vignette", index)
		var zone := root_vignettes.get_child(index) as Node3D
		if not zone.visible or zone.get_node_or_null("CollisionLaboratoireSol") == null:
			_fail("Zone complète non parcourable : %d" % index)
			return
	print("NOX_PROTOCOL_PHASE3_LAB_VALIDATION_READY vignettes=5")
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
