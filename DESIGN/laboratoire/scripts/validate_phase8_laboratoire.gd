extends SceneTree

const EXPECTED_SCREENS := 3


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
	var preview := laboratory.get_node_or_null("InterfacePhase8/Phase8Preview") as Control
	if preview == null:
		_fail("Prévisualisation phase 8 absente")
		return
	var menu := laboratory.get_node_or_null("InterfaceSelection/MenuSelection") as PanelContainer
	if menu == null or _count_phase8_buttons(menu) != EXPECTED_SCREENS:
		_fail("Entrées de validation phase 8 incomplètes")
		return
	for screen_index: int in EXPECTED_SCREENS:
		laboratory.call("_show_phase8_preview", screen_index)
		if not preview.visible:
			_fail("Écran phase 8 non affiché : %d" % screen_index)
			return
		var content := preview.get_node_or_null("Contenu") as Control
		if content == null or content.get_child_count() < 4:
			_fail("Contenu insuffisant : %d" % screen_index)
			return
	print("NOX_PROTOCOL_PHASE8_LAB_VALIDATION_READY screens=%d" % EXPECTED_SCREENS)
	quit(0)


func _count_phase8_buttons(node: Node) -> int:
	var labels := [
		"Effets d’armes et impacts", "Joueur, zombie et interactions",
		"Porte, quête et extraction",
	]
	var count := 1 if node is Button and node.text in labels else 0
	for child: Node in node.get_children():
		count += _count_phase8_buttons(child)
	return count


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
