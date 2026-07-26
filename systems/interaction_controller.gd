class_name InteractionController
extends Node3D

signal target_changed(target)
signal interaction_activated(target)

@onready var interaction_probe: RayCast3D = $InteractionProbe

var _player: Node
var _current_target
var _interact_was_pressed := false


func configure(player: Node) -> void:
	_player = player


func _physics_process(_delta: float) -> void:
	var is_pressed := Input.is_action_pressed("interact")
	if _player == null or not _player.is_physics_processing() or GameSession.state != GameSession.State.PLAYING:
		_interact_was_pressed = is_pressed
		_set_current_target(null)
		return
	_refresh_target()
	if should_activate(is_pressed, _interact_was_pressed) and _current_target != null:
		if _current_target.interact(_player):
			interaction_activated.emit(_current_target)
	_interact_was_pressed = is_pressed


func get_current_target():
	return _current_target


func _refresh_target() -> void:
	var next_target
	if interaction_probe.is_colliding():
		next_target = _find_interactable(interaction_probe.get_collider())
	if next_target != null and not next_target.can_interact(_player):
		next_target = null
	_set_current_target(next_target)


func _find_interactable(collider: Object):
	var candidate := collider as Node
	while candidate != null:
		if (
			candidate.has_method("can_interact")
			and candidate.has_method("interact")
			and candidate.has_method("get_interaction_prompt")
		):
			return candidate
		candidate = candidate.get_parent()
	return null


func _set_current_target(next_target) -> void:
	if _current_target == next_target:
		return
	if is_instance_valid(_current_target):
		if _current_target.interaction_state_changed.is_connected(_on_target_state_changed):
			_current_target.interaction_state_changed.disconnect(_on_target_state_changed)
		if _current_target.tree_exiting.is_connected(_on_target_exiting):
			_current_target.tree_exiting.disconnect(_on_target_exiting)
		if _current_target.has_method("on_target_lost"):
			_current_target.on_target_lost()
	_current_target = next_target
	if _current_target != null:
		_current_target.interaction_state_changed.connect(_on_target_state_changed)
		_current_target.tree_exiting.connect(_on_target_exiting)
	target_changed.emit(_current_target)


func _on_target_state_changed() -> void:
	if _current_target != null and not _current_target.can_interact(_player):
		_set_current_target(null)
	elif _current_target != null:
		target_changed.emit(_current_target)


func _on_target_exiting() -> void:
	_set_current_target(null)


static func should_activate(is_pressed: bool, was_pressed: bool) -> bool:
	return is_pressed and not was_pressed
