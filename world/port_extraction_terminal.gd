class_name PortExtractionTerminal
extends "res://systems/interactable.gd"

signal extraction_requested

var is_available := false


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	display_name = "Point d'extraction"
	action_label = "Déclencher l'extraction"
	_create_visual()


func set_available(should_be_available: bool) -> void:
	is_available = should_be_available
	interaction_state_changed.emit()


func can_interact(player: Node) -> bool:
	return is_available and super(player)


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	if not GameSession.try_purchase(display_name, price_credits):
		return false
	set_available(false)
	extraction_requested.emit()
	interaction_activated.emit(player)
	return true


func get_interaction_prompt() -> String:
	if not is_available:
		return "Extraction indisponible : atteignez la manche cible"
	return super()


func _create_visual() -> void:
	var body := StaticBody3D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)
	var visual := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 1.0
	mesh.bottom_radius = 1.2
	mesh.height = 2.0
	visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.12, 0.72, 0.82, 1.0)
	material.emission_enabled = true
	material.emission = Color(0.04, 0.35, 0.48, 1.0)
	visual.material_override = material
	body.add_child(visual)
	var collision := CollisionShape3D.new()
	var shape := CylinderShape3D.new()
	shape.radius = 1.2
	shape.height = 2.0
	collision.shape = shape
	collision.position.y = 1.0
	body.add_child(collision)
	var interaction_collision := CollisionShape3D.new()
	var interaction_shape := CylinderShape3D.new()
	interaction_shape.radius = 2.0
	interaction_shape.height = 2.5
	interaction_collision.shape = interaction_shape
	interaction_collision.position.y = 1.1
	add_child(interaction_collision)
	var label := Label3D.new()
	label.text = "EXTRACTION"
	label.position.y = 2.6
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 42
	label.outline_size = 6
	add_child(label)
