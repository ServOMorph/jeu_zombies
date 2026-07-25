extends RefCounted

const MINIMUM_FPS := 50.0
const MAXIMUM_FRAME_TIME_SECONDS := 1.0 / MINIMUM_FPS
const SLOW_FRAME_HISTORY_LIMIT := 20

var measurement_duration := 0.0
var measurement_frame_count := 0
var minimum_fps := INF
var worst_frame_time_ms := 0.0
var slow_frame_count := 0
var current_slow_sequence_seconds := 0.0
var longest_slow_sequence_seconds := 0.0
var last_slow_frame_time_ms := 0.0
var last_slow_frame_at_seconds := 0.0
var last_frame_time_ms := 0.0
var slow_frame_history: Array[Dictionary] = []


func reset() -> void:
	measurement_duration = 0.0
	measurement_frame_count = 0
	minimum_fps = INF
	worst_frame_time_ms = 0.0
	slow_frame_count = 0
	current_slow_sequence_seconds = 0.0
	longest_slow_sequence_seconds = 0.0
	last_slow_frame_time_ms = 0.0
	last_slow_frame_at_seconds = 0.0
	last_frame_time_ms = 0.0
	slow_frame_history.clear()


func record_frame(delta: float) -> void:
	if delta <= 0.0:
		return

	last_frame_time_ms = delta * 1000.0
	measurement_duration += delta
	measurement_frame_count += 1
	minimum_fps = minf(minimum_fps, 1.0 / delta)
	worst_frame_time_ms = maxf(worst_frame_time_ms, last_frame_time_ms)
	if delta <= MAXIMUM_FRAME_TIME_SECONDS:
		current_slow_sequence_seconds = 0.0
		return

	slow_frame_count += 1
	current_slow_sequence_seconds += delta
	longest_slow_sequence_seconds = maxf(
		longest_slow_sequence_seconds,
		current_slow_sequence_seconds
	)
	last_slow_frame_time_ms = last_frame_time_ms
	last_slow_frame_at_seconds = measurement_duration
	if slow_frame_history.size() == SLOW_FRAME_HISTORY_LIMIT:
		slow_frame_history.pop_front()
	slow_frame_history.append({
		"duration_ms": last_frame_time_ms,
		"at_seconds": last_slow_frame_at_seconds,
	})


func average_fps() -> float:
	if measurement_duration <= 0.0:
		return 0.0
	return float(measurement_frame_count) / measurement_duration


func displayed_minimum_fps() -> float:
	return 0.0 if minimum_fps == INF else minimum_fps
