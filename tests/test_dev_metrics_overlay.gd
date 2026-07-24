extends RefCounted

const OVERLAY_SCENE := preload("res://ui/dev_overlay/dev_metrics_overlay.tscn")
const EXPECTED_LABELS: PackedStringArray = [
	"FPS :",
	"Frame :",
	"Zombies :",
	"Nœuds :",
	"Mémoire :",
]


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var scene_tree := Engine.get_main_loop() as SceneTree
	var overlay := OVERLAY_SCENE.instantiate()
	scene_tree.root.add_child(overlay)
	overlay.call("_update_metrics", 0.016)

	var metrics_label := overlay.get_node("%MetricsLabel") as Label
	for expected_label: String in EXPECTED_LABELS:
		if expected_label not in metrics_label.text:
			failures.append("métrique absente de l’overlay : %s" % expected_label)

	if not overlay.visible:
		failures.append("overlay masqué dans une exécution de développement")

	var toggle_event := InputEventKey.new()
	toggle_event.keycode = KEY_F3
	toggle_event.pressed = true
	overlay.call("_unhandled_key_input", toggle_event)
	if overlay.visible:
		failures.append("F3 ne masque pas l’overlay")
	overlay.call("_unhandled_key_input", toggle_event)
	if not overlay.visible:
		failures.append("F3 ne réaffiche pas l’overlay")

	overlay.free()
	return failures
