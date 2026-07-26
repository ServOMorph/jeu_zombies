class_name WallWeaponBuy
extends "res://systems/interactable.gd"

signal weapon_purchased(weapon_name: String)

@export var weapon_definition: Resource
@export_range(0, 100000, 1) var ammo_price_credits := 150

var _pending_confirm := false
var _cached_player: Node


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	_create_visual()


func configure(buy_definition: Resource) -> void:
	weapon_definition = buy_definition.get("weapon")
	price_credits = int(buy_definition.get("price_credits"))
	ammo_price_credits = int(buy_definition.get("ammo_price_credits"))
	display_name = str(weapon_definition.get("weapon_name"))
	action_label = "Acheter"


func can_interact(player: Node) -> bool:
	if not super(player):
		return false
	_cached_player = player
	var weapon_controller = _get_weapon_controller(player)
	if weapon_controller == null:
		return false
	var owned_slot: int = weapon_controller.find_slot_for_definition(weapon_definition)
	if owned_slot != -1 and weapon_controller.is_slot_reserve_full(owned_slot):
		return false
	return true


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	var weapon_controller = _get_weapon_controller(player)
	if weapon_controller == null:
		return false

	var owned_slot: int = weapon_controller.find_slot_for_definition(weapon_definition)
	if owned_slot != -1:
		return _try_refill_ammo(weapon_controller, owned_slot, player)

	var free_slot: int = weapon_controller.first_free_slot()
	if free_slot != -1:
		return _try_buy_weapon(weapon_controller, free_slot, player)

	if not _pending_confirm:
		_pending_confirm = true
		interaction_state_changed.emit()
		return true

	_pending_confirm = false
	return _try_buy_weapon(weapon_controller, weapon_controller.active_slot, player)


func on_target_lost() -> void:
	_pending_confirm = false


func get_interaction_prompt() -> String:
	var weapon_controller = _get_weapon_controller(_cached_player)
	if weapon_controller == null:
		return "[E] %s — %d crédits" % [display_name, price_credits]

	var owned_slot: int = weapon_controller.find_slot_for_definition(weapon_definition)
	if owned_slot != -1:
		return "[E] Racheter munitions — %s — %d crédits" % [display_name, ammo_price_credits]

	if weapon_controller.first_free_slot() != -1:
		return "[E] Acheter — %s — %d crédits" % [display_name, price_credits]

	var active_name: String = weapon_controller.get_current_weapon_name()
	if _pending_confirm:
		return "[E] Confirmer le remplacement de %s par %s — %d crédits" % [active_name, display_name, price_credits]
	return "[E] Remplacer %s par %s — %d crédits" % [active_name, display_name, price_credits]


func _try_buy_weapon(weapon_controller, slot_index: int, player: Node) -> bool:
	if not GameSession.try_purchase(display_name, price_credits):
		return false
	weapon_controller.set_slot(slot_index, weapon_definition)
	weapon_controller.equip_slot(slot_index)
	weapon_purchased.emit(display_name)
	interaction_activated.emit(player)
	return true


func _try_refill_ammo(weapon_controller, slot_index: int, player: Node) -> bool:
	if not GameSession.try_purchase("%s — munitions" % display_name, ammo_price_credits):
		return false
	weapon_controller.refill_reserve(slot_index)
	interaction_activated.emit(player)
	return true


func _get_weapon_controller(player: Node):
	if player == null:
		return null
	return player.get("weapon_controller")


func _create_visual() -> void:
	var body := StaticBody3D.new()
	body.name = "RackBody"
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)

	var rack_size := Vector3(1.1, 1.5, 0.4)

	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = rack_size
	visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.5, 0.42, 0.1, 1.0)
	material.metallic = 0.6
	material.roughness = 0.4
	material.emission_enabled = true
	material.emission = Color(0.32, 0.24, 0.02, 1.0)
	visual.material_override = material
	body.add_child(visual)

	var collision_shape := CollisionShape3D.new()
	collision_shape.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = rack_size
	collision_shape.shape = shape
	body.add_child(collision_shape)

	var interaction_collision_shape := CollisionShape3D.new()
	interaction_collision_shape.name = "InteractionCollisionShape3D"
	var interaction_shape := BoxShape3D.new()
	interaction_shape.size = rack_size + Vector3(0.5, 0.5, 0.8)
	interaction_collision_shape.shape = interaction_shape
	add_child(interaction_collision_shape)

	var label := Label3D.new()
	label.text = display_name
	label.position = Vector3(0.0, rack_size.y * 0.5 + 0.3, 0.0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 34
	label.outline_size = 5
	add_child(label)
