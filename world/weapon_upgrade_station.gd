class_name WeaponUpgradeStation
extends "res://systems/interactable.gd"

const COMBAT_AUDIO_FEEDBACK := preload("res://weapons/combat_audio_feedback.gd")
const FLASH_DURATION_SECONDS := 0.4

signal weapon_upgraded(weapon_name: String)

var _cached_player: Node
var _visual_material: StandardMaterial3D
var _flash_timer: Timer
var _audio_player: AudioStreamPlayer


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	action_label = "Améliorer"
	if display_name == "Objet":
		display_name = "Station d'amélioration"
	_flash_timer = Timer.new()
	_flash_timer.one_shot = true
	_flash_timer.wait_time = FLASH_DURATION_SECONDS
	_flash_timer.timeout.connect(_on_flash_finished)
	add_child(_flash_timer)
	_create_visual()
	_create_audio()


func configure(station_definition: Resource) -> void:
	price_credits = int(station_definition.get("price_credits"))
	display_name = "Station d'amélioration"


func can_interact(player: Node) -> bool:
	if not super(player):
		return false
	_cached_player = player
	return _get_weapon_controller(player) != null


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	var weapon_controller = _get_weapon_controller(player)
	if weapon_controller.is_knife_active() or weapon_controller.get_current_definition() == null:
		return false
	if weapon_controller.is_slot_upgraded(weapon_controller.active_slot):
		return false
	if not GameSession.try_purchase(display_name, price_credits):
		return false
	if not weapon_controller.upgrade_slot(weapon_controller.active_slot):
		return false
	_play_feedback()
	weapon_upgraded.emit(weapon_controller.get_current_weapon_name())
	interaction_activated.emit(player)
	return true


func get_interaction_prompt() -> String:
	var weapon_controller = _get_weapon_controller(_cached_player)
	if weapon_controller == null:
		return "[E] %s — %d crédits" % [display_name, price_credits]
	if weapon_controller.is_knife_active():
		return "Équipez une arme à feu pour l'améliorer"
	var definition = weapon_controller.get_current_definition()
	if definition == null:
		return "Équipez une arme à feu pour l'améliorer"
	if weapon_controller.is_slot_upgraded(weapon_controller.active_slot):
		return "Déjà amélioré : %s" % str(definition.weapon_name)
	return "[E] Améliorer %s — %d crédits" % [str(definition.weapon_name), price_credits]


func _get_weapon_controller(player: Node):
	if player == null:
		return null
	return player.get("weapon_controller")


func _play_feedback() -> void:
	if _audio_player != null:
		_audio_player.play()
	if _visual_material != null:
		_visual_material.emission_energy_multiplier = 6.0
	_flash_timer.start()


func _on_flash_finished() -> void:
	if _visual_material != null:
		_visual_material.emission_energy_multiplier = 1.5


func _create_audio() -> void:
	_audio_player = AudioStreamPlayer.new()
	_audio_player.stream = COMBAT_AUDIO_FEEDBACK.create_tone_stream(520.0, 0.35, 0.2)
	_audio_player.volume_db = -10.0
	add_child(_audio_player)


func _create_visual() -> void:
	var body := StaticBody3D.new()
	body.name = "StationBody"
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)

	var station_size := Vector3(1.0, 1.4, 0.9)

	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = station_size
	visual.mesh = mesh
	_visual_material = StandardMaterial3D.new()
	_visual_material.albedo_color = Color(0.1, 0.5, 0.56, 1.0)
	_visual_material.metallic = 0.7
	_visual_material.roughness = 0.3
	_visual_material.emission_enabled = true
	_visual_material.emission = Color(0.08, 0.7, 0.8, 1.0)
	_visual_material.emission_energy_multiplier = 1.5
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
