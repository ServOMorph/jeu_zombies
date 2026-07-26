class_name HelixDoor
extends Node3D

signal state_changed(is_open: bool)

@export var starts_open := true
@export_range(1.0, 8.0, 0.1) var width := 4.0
@export_range(2.0, 6.0, 0.1) var height := 3.5

var is_open := true

var _panel: MeshInstance3D
var _collision_shape: CollisionShape3D
var _navigation_link: NavigationLink3D


func _ready() -> void:
	_create_panel()
	set_open(starts_open, false)


func set_open(should_open: bool, emit_change := true) -> void:
	is_open = should_open
	if _panel != null:
		_panel.position.y = height if is_open else height * 0.5
	if _collision_shape != null:
		_collision_shape.set_deferred("disabled", is_open)
	if _navigation_link != null:
		_navigation_link.enabled = is_open
		NavigationServer3D.link_set_enabled(_navigation_link.get_rid(), is_open)
	if emit_change:
		state_changed.emit(is_open)


func configure_navigation_link(start_point: Vector3, end_point: Vector3) -> void:
	_navigation_link = NavigationLink3D.new()
	_navigation_link.name = "NavigationLink3D"
	_navigation_link.start_position = to_local(start_point)
	_navigation_link.end_position = to_local(end_point)
	_navigation_link.bidirectional = true
	add_child(_navigation_link)
	_navigation_link.enabled = is_open


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
	body.add_child(_collision_shape)
