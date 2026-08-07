class_name QuestDeploymentPoint
extends "res://systems/interactable.gd"

const COMBAT_AUDIO_FEEDBACK := preload("res://weapons/combat_audio_feedback.gd")

signal antidote_deployed

var point_id := ""
var _visual_material: StandardMaterial3D
var _audio_player: AudioStreamPlayer


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	action_label = "Déployer"
	if display_name == "Objet":
		display_name = "Point de déploiement"
	GameSession.session_reset.connect(_on_session_reset)
	QuestController.state_changed.connect(_on_quest_state_changed)
	_create_visual()
	_create_audio()
	_refresh_state()


func configure(point_definition: Resource) -> void:
	point_id = str(point_definition.get("point_id"))
	display_name = str(point_definition.get("display_name"))


func can_interact(player: Node) -> bool:
	if not super(player):
		return false
	return QuestController.state == QuestController.State.DEPLOYER_ANTIDOTE


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	if not QuestController.try_advance(QuestController.State.ACTIVER_EXTRACTION):
		return false
	if _audio_player != null:
		_audio_player.play()
	interaction_activated.emit(player)
	antidote_deployed.emit()
	_refresh_state()
	return true


func get_interaction_prompt() -> String:
	if QuestController.state == QuestController.State.DEPLOYER_ANTIDOTE:
		return "[E] Déployer l'antidote"
	if _is_state_before_deployment():
		return "Antidote non fabriqué"
	return "Antidote déployé"


func _on_quest_state_changed(_previous_state: int, _new_state: int) -> void:
	_refresh_state()


func _on_session_reset() -> void:
	_refresh_state()


func _refresh_state() -> void:
	var deployed := _state_index() > _deploy_index()
	if _visual_material != null:
		_visual_material.emission_energy_multiplier = 0.8 if deployed else 1.4


func _is_state_before_deployment() -> bool:
	return _state_index() < _deploy_index()


func _state_index() -> int:
	return QuestController.ORDER.find(QuestController.state)


func _deploy_index() -> int:
	return QuestController.ORDER.find(QuestController.State.DEPLOYER_ANTIDOTE)


func _create_audio() -> void:
	_audio_player = AudioStreamPlayer.new()
	_audio_player.stream = COMBAT_AUDIO_FEEDBACK.create_tone_stream(260.0, 0.5, 0.2)
	_audio_player.volume_db = -10.0
	add_child(_audio_player)


func _create_visual() -> void:
	var body := StaticBody3D.new()
	body.name = "DeploymentPointBody"
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)

	var point_size := Vector3(1.0, 1.2, 1.0)

	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = point_size
	visual.mesh = mesh
	_visual_material = StandardMaterial3D.new()
	_visual_material.albedo_color = Color(0.18, 0.72, 0.64, 1.0)
	_visual_material.metallic = 0.5
	_visual_material.roughness = 0.3
	_visual_material.emission_enabled = true
	_visual_material.emission = Color(0.1, 0.7, 0.6, 1.0)
	_visual_material.emission_energy_multiplier = 1.4
	visual.material_override = _visual_material
	body.add_child(visual)

	var collision_shape := CollisionShape3D.new()
	collision_shape.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = point_size
	collision_shape.shape = shape
	body.add_child(collision_shape)

	var interaction_collision_shape := CollisionShape3D.new()
	interaction_collision_shape.name = "InteractionCollisionShape3D"
	var interaction_shape := BoxShape3D.new()
	interaction_shape.size = point_size + Vector3(0.6, 0.6, 0.9)
	interaction_collision_shape.shape = interaction_shape
	add_child(interaction_collision_shape)

	var label := Label3D.new()
	label.text = display_name
	label.position = Vector3(0.0, point_size.y * 0.5 + 0.3, 0.0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 34
	label.outline_size = 5
	add_child(label)
