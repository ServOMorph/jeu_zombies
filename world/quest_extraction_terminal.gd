class_name QuestExtractionTerminal
extends "res://systems/interactable.gd"

const COMBAT_AUDIO_FEEDBACK := preload("res://weapons/combat_audio_feedback.gd")

signal defense_finale_started
signal victory_triggered

var terminal_id := ""
var _visual_material: StandardMaterial3D
var _audio_player: AudioStreamPlayer


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	action_label = "Activer"
	if display_name == "Objet":
		display_name = "Terminal d'extraction"
	GameSession.session_reset.connect(_on_session_reset)
	QuestController.state_changed.connect(_on_quest_state_changed)
	_create_visual()
	_create_audio()
	_refresh_state()


func configure(terminal_definition: Resource) -> void:
	terminal_id = str(terminal_definition.get("terminal_id"))
	display_name = str(terminal_definition.get("display_name"))


func can_interact(player: Node) -> bool:
	if not super(player):
		return false
	return (
		QuestController.state == QuestController.State.ACTIVER_EXTRACTION
		or QuestController.state == QuestController.State.REJOINDRE_EXTRACTION
	)


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	var target_state := (
		QuestController.State.DEFENSE_FINALE
		if QuestController.state == QuestController.State.ACTIVER_EXTRACTION
		else QuestController.State.VICTOIRE
	)
	if not QuestController.try_advance(target_state):
		return false
	if _audio_player != null:
		_audio_player.play()
	interaction_activated.emit(player)
	if target_state == QuestController.State.DEFENSE_FINALE:
		defense_finale_started.emit()
	else:
		GameSession.finish_session(GameSession.State.VICTORY)
		victory_triggered.emit()
	_refresh_state()
	return true


func get_interaction_prompt() -> String:
	if QuestController.state == QuestController.State.ACTIVER_EXTRACTION:
		return "[E] Activer le protocole d'extraction"
	if QuestController.state == QuestController.State.REJOINDRE_EXTRACTION:
		return "[E] Rejoindre l'extraction"
	if _state_index() < _activate_index():
		return "Terminal verrouillé — déployez l'antidote"
	return "Protocole d'extraction activé"


func _on_quest_state_changed(_previous_state: int, _new_state: int) -> void:
	_refresh_state()


func _on_session_reset() -> void:
	_refresh_state()


func _refresh_state() -> void:
	var active := _state_index() >= _activate_index()
	if _visual_material != null:
		_visual_material.emission_energy_multiplier = 2.4 if active else 0.9


func _state_index() -> int:
	return QuestController.ORDER.find(QuestController.state)


func _activate_index() -> int:
	return QuestController.ORDER.find(QuestController.State.ACTIVER_EXTRACTION)


func _create_audio() -> void:
	_audio_player = AudioStreamPlayer.new()
	_audio_player.stream = COMBAT_AUDIO_FEEDBACK.create_tone_stream(420.0, 0.6, 0.2)
	_audio_player.volume_db = -10.0
	add_child(_audio_player)


func _create_visual() -> void:
	var body := StaticBody3D.new()
	body.name = "ExtractionTerminalBody"
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)

	var terminal_size := Vector3(0.9, 1.6, 0.6)

	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = terminal_size
	visual.mesh = mesh
	_visual_material = StandardMaterial3D.new()
	_visual_material.albedo_color = Color(0.78, 0.62, 0.14, 1.0)
	_visual_material.metallic = 0.6
	_visual_material.roughness = 0.3
	_visual_material.emission_enabled = true
	_visual_material.emission = Color(0.8, 0.6, 0.1, 1.0)
	_visual_material.emission_energy_multiplier = 0.9
	visual.material_override = _visual_material
	body.add_child(visual)

	var collision_shape := CollisionShape3D.new()
	collision_shape.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = terminal_size
	collision_shape.shape = shape
	body.add_child(collision_shape)

	var interaction_collision_shape := CollisionShape3D.new()
	interaction_collision_shape.name = "InteractionCollisionShape3D"
	var interaction_shape := BoxShape3D.new()
	interaction_shape.size = terminal_size + Vector3(0.6, 0.6, 0.9)
	interaction_collision_shape.shape = interaction_shape
	add_child(interaction_collision_shape)

	var label := Label3D.new()
	label.text = display_name
	label.position = Vector3(0.0, terminal_size.y * 0.5 + 0.3, 0.0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 34
	label.outline_size = 5
	add_child(label)
