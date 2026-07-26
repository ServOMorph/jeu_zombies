extends CharacterBody3D

const SPEED := 4.5
const SPRINT_SPEED := 7.0
const MOUSE_SENSITIVITY := 0.0022
const GRAVITY := 18.0

var _camera: Camera3D
var _pitch := 0.0
var _input_enabled := true


func _ready() -> void:
	_create_body()
	if DisplayServer.get_name() != "headless":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _create_body() -> void:
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.35
	capsule.height = 1.8
	collision.shape = capsule
	collision.position.y = 0.9
	add_child(collision)

	_camera = Camera3D.new()
	_camera.name = "CameraFPS"
	_camera.position.y = 1.62
	_camera.current = true
	_camera.fov = 75.0
	add_child(_camera)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("lab_cursor"):
		_input_enabled = not _input_enabled
		Input.mouse_mode = (
			Input.MOUSE_MODE_CAPTURED
			if _input_enabled
			else Input.MOUSE_MODE_VISIBLE
		)
		get_viewport().set_input_as_handled()
		return

	if (
		event is InputEventMouseMotion
		and _input_enabled
		and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	):
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		_pitch = clampf(
			_pitch - event.relative.y * MOUSE_SENSITIVITY,
			deg_to_rad(-85.0),
			deg_to_rad(85.0)
		)
		_camera.rotation.x = _pitch


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0.0

	var input_vector := Vector2.ZERO
	if _input_enabled:
		input_vector = Input.get_vector(
			"lab_move_left",
			"lab_move_right",
			"lab_move_forward",
			"lab_move_backward"
		)

	var direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y))
	direction.y = 0.0
	direction = direction.normalized()
	var speed := SPRINT_SPEED if Input.is_action_pressed("lab_sprint") else SPEED
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()

