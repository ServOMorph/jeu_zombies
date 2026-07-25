extends CanvasLayer

const DevPerformanceMetrics := preload("res://ui/dev_overlay/dev_performance_metrics.gd")

const UPDATE_INTERVAL_SECONDS := 1.0
const ARMING_DELAY_SECONDS := 1.0
const BYTES_PER_MEBIBYTE := 1024.0 * 1024.0

@onready var metrics_label: Label = %MetricsLabel

var _elapsed_since_display_update := 0.0
var _arming_remaining_seconds := 0.0
var _metrics := DevPerformanceMetrics.new()

var measurement_duration: float:
	get:
		return _metrics.measurement_duration
var measurement_frame_count: int:
	get:
		return _metrics.measurement_frame_count
var slow_frame_count: int:
	get:
		return _metrics.slow_frame_count
var longest_slow_sequence_seconds: float:
	get:
		return _metrics.longest_slow_sequence_seconds
var is_measurement_armed: bool:
	get:
		return _arming_remaining_seconds <= 0.0


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	_update_metrics(0.0)
	print("NOX_PROTOCOL_DEV_OVERLAY_READY")


func _process(delta: float) -> void:
	_record_frame(delta)
	if not visible:
		return
	_elapsed_since_display_update += delta
	if _elapsed_since_display_update < UPDATE_INTERVAL_SECONDS:
		return
	_update_metrics(delta)
	_elapsed_since_display_update = 0.0


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
	_metrics.reset()
	_arming_remaining_seconds = ARMING_DELAY_SECONDS
	_elapsed_since_display_update = UPDATE_INTERVAL_SECONDS
	_update_metrics(0.0)


func _record_frame(delta: float) -> void:
	if delta <= 0.0:
		return
	if _arming_remaining_seconds > 0.0:
		_arming_remaining_seconds = maxf(0.0, _arming_remaining_seconds - delta)
		return
	_metrics.record_frame(delta)


func _update_metrics(frame_delta: float) -> void:
	var frame_time_ms := _metrics.last_frame_time_ms
	if frame_time_ms <= 0.0:
		frame_time_ms = frame_delta * 1000.0
	var zombie_count := get_tree().get_node_count_in_group("zombies")
	var node_count := int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var memory_mib := (
		Performance.get_monitor(Performance.MEMORY_STATIC) / BYTES_PER_MEBIBYTE
	)
	var arming_state := "active" if is_measurement_armed else "dans %.1f s" % _arming_remaining_seconds
	metrics_label.text = (
		"FPS : %d\nFrame : %.2f ms\nMoyenne : %.0f FPS\nMinimum : %.0f FPS\nPire frame : %.2f ms\nSous 50 FPS : %d\nSéquence max : %.3f s\nDernière chute : %.2f ms à %.1f s\nMesure : %s\nVSync : %s\nZombies : %d\nNœuds : %d\nMémoire : %.1f Mio\n[F3] Masquer · [F4] Réinitialiser"
		% [
			Engine.get_frames_per_second(),
			frame_time_ms,
			_metrics.average_fps(),
			_metrics.displayed_minimum_fps(),
			_metrics.worst_frame_time_ms,
			_metrics.slow_frame_count,
			_metrics.longest_slow_sequence_seconds,
			_metrics.last_slow_frame_time_ms,
			_metrics.last_slow_frame_at_seconds,
			arming_state,
			_vsync_state_label(),
			zombie_count,
			node_count,
			memory_mib,
		]
	)


func _vsync_state_label() -> String:
	match DisplayServer.window_get_vsync_mode():
		DisplayServer.VSYNC_DISABLED:
			return "désactivée"
		DisplayServer.VSYNC_ENABLED:
			return "activée"
		DisplayServer.VSYNC_ADAPTIVE:
			return "adaptative"
		DisplayServer.VSYNC_MAILBOX:
			return "mailbox"
		_:
			return "inconnue"
