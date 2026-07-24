extends CanvasLayer

const UPDATE_INTERVAL_SECONDS := 0.25
const BYTES_PER_MEBIBYTE := 1024.0 * 1024.0

@onready var metrics_label: Label = %MetricsLabel

var _elapsed_since_update := 0.0


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return

	_update_metrics(0.0)
	print("NOX_PROTOCOL_DEV_OVERLAY_READY")


func _process(delta: float) -> void:
	if not visible:
		return

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


func _update_metrics(frame_delta: float) -> void:
	var frame_time_ms := frame_delta * 1000.0
	var zombie_count := get_tree().get_nodes_in_group("zombies").size()
	var node_count := int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var memory_mib := (
		Performance.get_monitor(Performance.MEMORY_STATIC) / BYTES_PER_MEBIBYTE
	)
	metrics_label.text = (
		"FPS : %d\nFrame : %.2f ms\nZombies : %d\nNœuds : %d\nMémoire : %.1f Mio\n[F3] Masquer"
		% [
			Engine.get_frames_per_second(),
			frame_time_ms,
			zombie_count,
			node_count,
			memory_mib,
		]
	)
