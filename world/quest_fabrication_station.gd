class_name QuestFabricationStation
extends "res://systems/interactable.gd"

const COMBAT_AUDIO_FEEDBACK := preload("res://weapons/combat_audio_feedback.gd")

signal fabrication_started
signal fabrication_completed

enum State { IDLE, FABRICATING }

var _state: State = State.IDLE
var _fabrication_timer: Timer
var _visual_material: StandardMaterial3D
var _fabrication_duration_seconds := 2.5
var _audio_player: AudioStreamPlayer


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	action_label = "Fabriquer"
	if display_name == "Objet":
		display_name = "Station de fabrication"
	_fabrication_timer = Timer.new()
	_fabrication_timer.one_shot = true
	_fabrication_timer.wait_time = _fabrication_duration_seconds
	_fabrication_timer.timeout.connect(_on_fabrication_finished)
	add_child(_fabrication_timer)
	GameSession.session_reset.connect(_on_session_reset)
	GameSession.session_started.connect(_on_session_started)
	_create_visual()
	_create_audio()


func configure(station_definition: Resource) -> void:
	display_name = "Station de fabrication"
	_fabrication_duration_seconds = float(station_definition.get("fabrication_duration_seconds"))
	if _fabrication_timer != null:
		_fabrication_timer.wait_time = _fabrication_duration_seconds


func can_interact(player: Node) -> bool:
	if not super(player):
		return false
	if _state == State.FABRICATING:
		return true
	return QuestController.state == QuestController.State.FABRIQUER_ANTIDOTE and QuestController.has_all_components()


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	if _state == State.FABRICATING:
		return false
	_state = State.FABRICATING
	interaction_state_changed.emit()
	fabrication_started.emit()
	if _audio_player != null:
		_audio_player.play()
	if _visual_material != null:
		_visual_material.emission_energy_multiplier = 3.0
	_fabrication_timer.start()
	interaction_activated.emit(player)
	return true


func get_interaction_prompt() -> String:
	if _state == State.FABRICATING:
		return "Fabrication en cours..."
	if QuestController.state != QuestController.State.FABRIQUER_ANTIDOTE:
		return "Récupérez les trois composants avant de fabriquer l'antidote"
	return "[E] %s" % display_name


func _on_fabrication_finished() -> void:
	if _state != State.FABRICATING:
		return
	_state = State.IDLE
	QuestController.try_advance(QuestController.State.DEPLOYER_ANTIDOTE)
	if _audio_player != null:
		_audio_player.play()
	if _visual_material != null:
		_visual_material.emission_energy_multiplier = 1.4
	interaction_state_changed.emit()
	fabrication_completed.emit()


func _on_session_reset() -> void:
	_reset_state()


func _on_session_started(_session_id: int) -> void:
	_reset_state()


func _reset_state() -> void:
	_fabrication_timer.stop()
	_state = State.IDLE


func _create_audio() -> void:
	_audio_player = AudioStreamPlayer.new()
	_audio_player.stream = COMBAT_AUDIO_FEEDBACK.create_tone_stream(340.0, 0.4, 0.2)
	_audio_player.volume_db = -10.0
	add_child(_audio_player)


func _create_visual() -> void:
	var body := StaticBody3D.new()
	body.name = "FabricationStationBody"
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)

	var station_size := Vector3(1.2, 1.5, 1.0)

	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = station_size
	visual.mesh = mesh
	_visual_material = StandardMaterial3D.new()
	_visual_material.albedo_color = Color(0.62, 0.16, 0.5, 1.0)
	_visual_material.metallic = 0.6
	_visual_material.roughness = 0.35
	_visual_material.emission_enabled = true
	_visual_material.emission = Color(0.6, 0.1, 0.5, 1.0)
	_visual_material.emission_energy_multiplier = 1.4
	visual.material_override = _visual_material
	body.add_child(visual)

	var collision_shape := CollisionShape3D.new()
	collision_shape.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = station_size
	collision_shape.shape = shape
	body.add_child(collision_shape)

	var interaction_collision_shape := CollisionShape3D.new()
	interaction_collision_shape.name = "InteractionCollisionShape3D"
	var interaction_shape := BoxShape3D.new()
	interaction_shape.size = station_size + Vector3(0.6, 0.6, 0.9)
	interaction_collision_shape.shape = interaction_shape
	add_child(interaction_collision_shape)

	var label := Label3D.new()
	label.text = display_name
	label.position = Vector3(0.0, station_size.y * 0.5 + 0.3, 0.0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 34
	label.outline_size = 5
	add_child(label)
