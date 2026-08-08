class_name HelixDoor
extends "res://systems/interactable.gd"

signal state_changed(is_open: bool)

@export var definition: Resource
@export var starts_open := false
@export_range(1.0, 8.0, 0.1) var width := 4.0
@export_range(2.0, 6.0, 0.1) var height := 3.5

const NAVIGATION_OBSTACLE_EXTENT := 3.0

var is_open := false

var _panel: MeshInstance3D
var _collision_shape: CollisionShape3D
var _interaction_collision_shape: CollisionShape3D
var _navigation_obstacle: NavigationObstacle3D


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	_create_panel()
	set_open(starts_open, false)


func configure(door_definition: Resource) -> void:
	definition = door_definition
	starts_open = bool(definition.get("starts_open"))
	action_label = "Ouvrir"
	display_name = str(definition.get("display_name"))
	price_credits = int(definition.get("price_credits"))


func can_interact(player: Node) -> bool:
	return not is_open and super(player)


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	if not GameSession.try_purchase(display_name, price_credits):
		return false
	set_open(true)
	interaction_activated.emit(player)
	return true


func set_open(should_open: bool, emit_change := true) -> void:
	is_open = should_open
	if _panel != null:
		_panel.position.y = height * 1.5 if is_open else height * 0.5
	if _collision_shape != null:
		_collision_shape.set_deferred("disabled", is_open)
	if _interaction_collision_shape != null:
		_interaction_collision_shape.set_deferred("disabled", is_open)
	set_interaction_enabled(not is_open)
	if _navigation_obstacle != null:
		_navigation_obstacle.affect_navigation_mesh = not is_open
	if emit_change:
		state_changed.emit(is_open)


func configure_navigation_obstacle() -> void:
	_navigation_obstacle = NavigationObstacle3D.new()
	_navigation_obstacle.name = "NavigationObstacle3D"
	_navigation_obstacle.avoidance_enabled = false
	_navigation_obstacle.height = height
	_navigation_obstacle.vertices = PackedVector3Array([
		Vector3(-NAVIGATION_OBSTACLE_EXTENT, 0.0, -NAVIGATION_OBSTACLE_EXTENT),
		Vector3(NAVIGATION_OBSTACLE_EXTENT, 0.0, -NAVIGATION_OBSTACLE_EXTENT),
		Vector3(NAVIGATION_OBSTACLE_EXTENT, 0.0, NAVIGATION_OBSTACLE_EXTENT),
		Vector3(-NAVIGATION_OBSTACLE_EXTENT, 0.0, NAVIGATION_OBSTACLE_EXTENT),
	])
	add_child(_navigation_obstacle)
	_navigation_obstacle.affect_navigation_mesh = not is_open


func _create_panel() -> void:
	var body := StaticBody3D.new()
	body.name = "DoorPanel"
	add_child(body)

	_panel = MeshInstance3D.new()
	_panel.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(width, height, 0.35)
	_panel.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.08, 0.38, 0.47, 1.0)
	material.metallic = 0.75
	material.roughness = 0.36
	material.emission_enabled = true
	material.emission = Color(0.02, 0.16, 0.21, 1.0)
	_panel.material_override = material
	body.add_child(_panel)

	_collision_shape = CollisionShape3D.new()
	_collision_shape.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = Vector3(width, height, 0.35)
	_collision_shape.shape = shape
	_collision_shape.position.y = height * 0.5
	body.add_child(_collision_shape)

	_interaction_collision_shape = CollisionShape3D.new()
	_interaction_collision_shape.name = "InteractionCollisionShape3D"
	var interaction_shape := BoxShape3D.new()
	interaction_shape.size = Vector3(width, height, 0.8)
	_interaction_collision_shape.shape = interaction_shape
	_interaction_collision_shape.position.y = height * 0.5
	add_child(_interaction_collision_shape)
