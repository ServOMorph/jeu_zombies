class_name MysteryBox
extends "res://systems/interactable.gd"

signal weapon_awarded(weapon_name: String)

const SPIN_DURATION_SECONDS := 1.4

enum State { IDLE, SPINNING, AWAITING_CONFIRM }

@export var possible_weapons: Array[Resource] = []

var _state: State = State.IDLE
var _drawn_weapon: Resource
var _cached_player: Node
var _rng := RandomNumberGenerator.new()
var _spin_timer: Timer


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	action_label = "Activer"
	if display_name == "Objet":
		display_name = "Caisse d'armes aléatoire"
	_spin_timer = Timer.new()
	_spin_timer.one_shot = true
	_spin_timer.wait_time = SPIN_DURATION_SECONDS
	_spin_timer.timeout.connect(resolve_spin)
	add_child(_spin_timer)
	GameSession.session_reset.connect(_on_session_reset)
	GameSession.session_started.connect(_on_session_started)
	_create_visual()


func configure(box_definition: Resource) -> void:
	price_credits = int(box_definition.get("price_credits"))
	possible_weapons = (box_definition.get("possible_weapons") as Array).duplicate()
	display_name = "Caisse d'armes aléatoire"


func can_interact(player: Node) -> bool:
	if not super(player):
		return false
	_cached_player = player
	if _state != State.IDLE:
		return true
	return _get_weapon_controller(player) != null and not possible_weapons.is_empty()


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	var weapon_controller = _get_weapon_controller(player)
	if weapon_controller == null:
		return false

	if _state == State.SPINNING:
		return false

	if _state == State.AWAITING_CONFIRM:
		return _confirm_award(weapon_controller, player)

	if not GameSession.try_purchase(display_name, price_credits):
		return false
	_drawn_weapon = pick_weapon(weapon_controller)
	_state = State.SPINNING
	interaction_state_changed.emit()
	_spin_timer.start()
	return true


func get_interaction_prompt() -> String:
	match _state:
		State.SPINNING:
			return "%s..." % display_name
		State.AWAITING_CONFIRM:
			return "[E] Récupérer %s" % str(_drawn_weapon.get("weapon_name"))
		_:
			return "[E] %s — %d crédits" % [display_name, price_credits]


func pick_weapon(weapon_controller) -> Resource:
	var current_definition = weapon_controller.get_current_definition() if weapon_controller != null else null
	var candidates: Array = possible_weapons
	if current_definition != null and possible_weapons.size() > 1:
		var filtered: Array = []
		for weapon: Resource in possible_weapons:
			if weapon != current_definition:
				filtered.append(weapon)
		if not filtered.is_empty():
			candidates = filtered
	return candidates[_rng.randi_range(0, candidates.size() - 1)]


func resolve_spin() -> void:
	if _state != State.SPINNING:
		return
	_state = State.AWAITING_CONFIRM
	interaction_state_changed.emit()


func _confirm_award(weapon_controller, player: Node) -> bool:
	var slot_index: int = weapon_controller.first_free_slot()
	if slot_index == -1:
		slot_index = weapon_controller.active_slot
	weapon_controller.set_slot(slot_index, _drawn_weapon)
	weapon_controller.equip_slot(slot_index)
	weapon_awarded.emit(str(_drawn_weapon.get("weapon_name")))
	interaction_activated.emit(player)
	_state = State.IDLE
	_drawn_weapon = null
	interaction_state_changed.emit()
	return true


func _on_session_reset() -> void:
	_reset_state()


func _on_session_started(_session_id: int) -> void:
	_reset_state()


func _reset_state() -> void:
	_spin_timer.stop()
	_state = State.IDLE
	_drawn_weapon = null


func _get_weapon_controller(player: Node):
	if player == null:
		return null
	return player.get("weapon_controller")


func _create_visual() -> void:
	var body := StaticBody3D.new()
	body.name = "CrateBody"
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)

	var crate_size := Vector3(1.4, 1.2, 1.4)

	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = crate_size
	visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.16, 0.14, 0.4, 1.0)
	material.metallic = 0.35
	material.roughness = 0.55
	material.emission_enabled = true
	material.emission = Color(0.1, 0.06, 0.3, 1.0)
	visual.material_override = material
	body.add_child(visual)

	var collision_shape := CollisionShape3D.new()
	collision_shape.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = crate_size
	collision_shape.shape = shape
	body.add_child(collision_shape)

	var interaction_collision_shape := CollisionShape3D.new()
	interaction_collision_shape.name = "InteractionCollisionShape3D"
	var interaction_shape := BoxShape3D.new()
	interaction_shape.size = crate_size + Vector3(0.6, 0.6, 0.9)
	interaction_collision_shape.shape = interaction_shape
	add_child(interaction_collision_shape)

	var label := Label3D.new()
	label.text = display_name
	label.position = Vector3(0.0, crate_size.y * 0.5 + 0.3, 0.0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 34
	label.outline_size = 5
	add_child(label)
