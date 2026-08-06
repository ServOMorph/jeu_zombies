class_name QuestComponent
extends "res://systems/interactable.gd"

var component_id := ""
var _visual: MeshInstance3D


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	action_label = "Récupérer"
	GameSession.session_reset.connect(_on_session_reset)
	_create_visual()
	_refresh_state()


func configure(component_definition: Resource) -> void:
	component_id = str(component_definition.get("component_id"))
	display_name = str(component_definition.get("display_name"))


func can_interact(player: Node) -> bool:
	if not super(player):
		return false
	return not QuestController.has_component(component_id)


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	if not QuestController.collect_component(component_id):
		return false
	interaction_activated.emit(player)
	_refresh_state()
	return true


func get_interaction_prompt() -> String:
	if QuestController.has_component(component_id):
		return "Composant récupéré"
	return "[E] Récupérer %s" % display_name


func _on_session_reset() -> void:
	_refresh_state()


func _refresh_state() -> void:
	var collected := QuestController.has_component(component_id)
	set_interaction_enabled(not collected)
	if _visual != null:
		_visual.visible = not collected


func _create_visual() -> void:
	var body := StaticBody3D.new()
	body.name = "ComponentBody"
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)

	var component_size := Vector3(0.5, 0.5, 0.5)

	_visual = MeshInstance3D.new()
	_visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = component_size
	_visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.62, 0.86, 0.24, 1.0)
	material.metallic = 0.1
	material.roughness = 0.25
	material.emission_enabled = true
	material.emission = Color(0.4, 0.9, 0.2, 1.0)
	material.emission_energy_multiplier = 1.6
	_visual.material_override = material
	_visual.position.y = component_size.y * 0.5 + 0.8
	body.add_child(_visual)

	var collision_shape := CollisionShape3D.new()
	collision_shape.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = component_size
	collision_shape.shape = shape
	collision_shape.position = _visual.position
	body.add_child(collision_shape)

	var interaction_collision_shape := CollisionShape3D.new()
	interaction_collision_shape.name = "InteractionCollisionShape3D"
	var interaction_shape := BoxShape3D.new()
	interaction_shape.size = component_size + Vector3(0.8, 0.8, 0.8)
	interaction_collision_shape.shape = interaction_shape
	interaction_collision_shape.position = _visual.position
	add_child(interaction_collision_shape)

	var label := Label3D.new()
	label.text = display_name
	label.position = Vector3(0.0, component_size.y + 1.1, 0.0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 34
	label.outline_size = 5
	add_child(label)
