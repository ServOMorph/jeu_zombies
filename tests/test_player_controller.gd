extends RefCounted

const PLAYER_CONTROLLER := preload("res://player/player_controller.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	if PLAYER_CONTROLLER.select_speed(false, false, 5.5, 8.0, 2.5) != 5.5:
		failures.append("la marche doit utiliser la vitesse de marche")
	if PLAYER_CONTROLLER.select_speed(false, true, 5.5, 8.0, 2.5) != 8.0:
		failures.append("la course doit utiliser la vitesse de course")
	if PLAYER_CONTROLLER.select_speed(true, true, 5.5, 8.0, 2.5) != 2.5:
		failures.append("l'accroupissement doit empêcher la course")

	var direction := Vector3.FORWARD
	var velocity_at_30_fps := _simulate_velocity(direction, 30, 1.0)
	var velocity_at_120_fps := _simulate_velocity(direction, 120, 1.0)
	if not velocity_at_30_fps.is_equal_approx(velocity_at_120_fps):
		failures.append("la vitesse doit rester stable entre 30 et 120 FPS")
	if not velocity_at_30_fps.is_equal_approx(direction * 5.5):
		failures.append("l'accélération doit atteindre la vitesse cible après une seconde")

	var stopped_velocity := PLAYER_CONTROLLER.resolve_horizontal_velocity(
		Vector3(5.5, 0.0, 0.0), Vector3.ZERO, 5.5, 28.0, 34.0, 1.0
	)
	if not stopped_velocity.is_zero_approx():
		failures.append("la décélération doit arrêter le joueur sans glissement résiduel")
	if not PLAYER_CONTROLLER.is_slope_walkable(30.0, 46.0):
		failures.append("la pente de 30 degres doit rester praticable")
	if PLAYER_CONTROLLER.is_slope_walkable(55.0, 46.0):
		failures.append("la pente de 55 degres doit etre refusee")
	return failures


func _simulate_velocity(direction: Vector3, frames_per_second: int, duration: float) -> Vector3:
	var velocity := Vector3.ZERO
	var delta := 1.0 / float(frames_per_second)
	var frame_count := int(duration * frames_per_second)
	for _frame in frame_count:
		velocity = PLAYER_CONTROLLER.resolve_horizontal_velocity(
			velocity, direction, 5.5, 28.0, 34.0, delta
		)
	return velocity
