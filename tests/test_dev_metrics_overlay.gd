extends RefCounted

const OVERLAY_SCENE := preload("res://ui/dev_overlay/dev_metrics_overlay.tscn")
const PERFORMANCE_METRICS := preload("res://ui/dev_overlay/dev_performance_metrics.gd")
const EXPECTED_LABELS: PackedStringArray = [
	"FPS :",
	"Frame :",
	"Moyenne :",
	"Minimum :",
	"Pire frame :",
	"Sous 50 FPS :",
	"Séquence max :",
	"Dernière chute :",
	"Mesure :",
	"VSync :",
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
			failures.append("métrique absente de l'overlay : %s" % expected_label)

	if not overlay.visible:
		failures.append("overlay masqué dans une exécution de développement")

	var toggle_event := InputEventKey.new()
	toggle_event.keycode = KEY_F3
	toggle_event.pressed = true
	overlay.call("_unhandled_key_input", toggle_event)
	if overlay.visible:
		failures.append("F3 ne masque pas l'overlay")
	overlay.call("_unhandled_key_input", toggle_event)
	if not overlay.visible:
		failures.append("F3 ne réaffiche pas l'overlay")

	var metrics := PERFORMANCE_METRICS.new()
	metrics.record_frame(0.016)
	metrics.record_frame(0.033)
	metrics.record_frame(0.033)
	metrics.record_frame(0.016)
	if metrics.slow_frame_count != 2:
		failures.append("les frames sous 50 FPS doivent être comptées")
	if not is_equal_approx(metrics.longest_slow_sequence_seconds, 0.066):
		failures.append("la durée de la séquence lente doit être conservée")
	if metrics.worst_frame_time_ms < 33.0:
		failures.append("la pire frame doit être conservée")
	if not is_equal_approx(metrics.average_fps(), 4.0 / 0.098):
		failures.append("la moyenne des FPS doit être calculée")
	if not is_equal_approx(metrics.displayed_minimum_fps(), 1.0 / 0.033):
		failures.append("le minimum des FPS doit être calculé")
	if metrics.slow_frame_history.size() != 2:
		failures.append("les frames lentes doivent être historisées")
	for _index in 21:
		metrics.record_frame(0.021)
	if metrics.slow_frame_history.size() != 20:
		failures.append("l'historique des frames lentes doit être borné")

	overlay.call("reset_measurement")
	overlay.call("_record_frame", 0.5)
	if overlay.measurement_frame_count != 0 or overlay.is_measurement_armed:
		failures.append("F4 doit armer la mesure après un délai d'une seconde")
	overlay.call("_record_frame", 0.5)
	overlay.call("_record_frame", 0.016)
	if overlay.measurement_frame_count != 1:
		failures.append("la collecte doit commencer après l'armement")

	overlay.visible = false
	overlay.call("_record_frame", 0.016)
	if overlay.measurement_frame_count != 2:
		failures.append("la collecte doit continuer lorsque l'overlay est masqué")
	overlay.visible = true

	var reset_event := InputEventKey.new()
	reset_event.keycode = KEY_F4
	reset_event.pressed = true
	overlay.call("_unhandled_key_input", reset_event)
	if overlay.measurement_duration != 0.0 or overlay.measurement_frame_count != 0:
		failures.append("F4 doit réinitialiser la mesure de performance")

	overlay.free()
	return failures
