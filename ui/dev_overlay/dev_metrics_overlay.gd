extends CanvasLayer

const UPDATE_INTERVAL_SECONDS := 0.25
const BYTES_PER_MEBIBYTE := 1024.0 * 1024.0
const MINIMUM_FPS := 50.0
const MAXIMUM_FRAME_TIME_SECONDS := 1.0 / MINIMUM_FPS

@onready var metrics_label: Label = %MetricsLabel

var _elapsed_since_update := 0.0
var measurement_duration := 0.0
var measurement_frame_count := 0
var minimum_fps := INF
var worst_frame_time_ms := 0.0
var slow_frame_count := 0
var _current_slow_sequence_seconds := 0.0
var longest_slow_sequence_seconds := 0.0
var last_slow_frame_time_ms := 0.0
var last_slow_frame_at_seconds := 0.0


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	_update_metrics(0.0)
	print("NOX_PROTOCOL_DEV_OVERLAY_READY")


func _process(delta: float) -> void:
	if not visible:
		return
	_record_frame(delta)
	_elapsed_since_update += delta
	if _elapsed_since_update < UPDATE_INTERVAL_SECONDS:
		return
	_update_metrics(delta)
	_elapsed_since_update = 0.0


func _unhandled_key_input(event: InputEvent) -> void:
	if (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F3
	):
		visible = not visible
		get_viewport().set_input_as_handled()
	elif (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F4
	):
		reset_measurement()
		get_viewport().set_input_as_handled()


func reset_measurement() -> void:
	measurement_duration = 0.0
	measurement_frame_count = 0
	minimum_fps = INF
	worst_frame_time_ms = 0.0
	slow_frame_count = 0
	_current_slow_sequence_seconds = 0.0
	longest_slow_sequence_seconds = 0.0
	last_slow_frame_time_ms = 0.0
	last_slow_frame_at_seconds = 0.0


func _record_frame(delta: float) -> void:
	if delta <= 0.0:
		return
	measurement_duration += delta
	measurement_frame_count += 1
	minimum_fps = minf(minimum_fps, 1.0 / delta)
	worst_frame_time_ms = maxf(worst_frame_time_ms, delta * 1000.0)
	if delta <= MAXIMUM_FRAME_TIME_SECONDS:
		_current_slow_sequence_seconds = 0.0
		return
	slow_frame_count += 1
	_current_slow_sequence_seconds += delta
	longest_slow_sequence_seconds = maxf(
		longest_slow_sequence_seconds,
		_current_slow_sequence_seconds
	)
	last_slow_frame_time_ms = delta * 1000.0
	last_slow_frame_at_seconds = measurement_duration


func _update_metrics(frame_delta: float) -> void:
	var frame_time_ms := frame_delta * 1000.0
	var zombie_count := get_tree().get_nodes_in_group("zombies").size()
	var node_count := int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var memory_mib := (
		Performance.get_monitor(Performance.MEMORY_STATIC) / BYTES_PER_MEBIBYTE
	)
	var average_fps := (
		float(measurement_frame_count) / measurement_duration
		if measurement_duration > 0.0
		else 0.0
	)
	var displayed_minimum := 0.0 if minimum_fps == INF else minimum_fps
	metrics_label.text = (
		"FPS : %d\nFrame : %.2f ms\nMoyenne : %.0f FPS\nMinimum : %.0f FPS\nPire frame : %.2f ms\nSous 50 FPS : %d\nSéquence max : %.3f s\nDernière chute : %.2f ms à %.1f s\nZombies : %d\nNœuds : %d\nMémoire : %.1f Mio\n[F3] Masquer · [F4] Réinitialiser"
		% [
			Engine.get_frames_per_second(),
			frame_time_ms,
			average_fps,
			displayed_minimum,
			worst_frame_time_ms,
			slow_frame_count,
			longest_slow_sequence_seconds,
			last_slow_frame_time_ms,
			last_slow_frame_at_seconds,
			zombie_count,
			node_count,
			memory_mib,
		]
	)
