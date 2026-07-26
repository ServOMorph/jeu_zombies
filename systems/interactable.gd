class_name Interactable
extends Area3D

signal interaction_state_changed
signal interaction_activated(player: Node)

@export var action_label := "Interagir"
@export var display_name := "Objet"
@export var price_credits := -1
@export var interaction_enabled := true


func can_interact(_player: Node) -> bool:
	return interaction_enabled and is_inside_tree()


func interact(player: Node) -> bool:
	if not can_interact(player):
		return false
	interaction_activated.emit(player)
	return true


func get_interaction_prompt() -> String:
	var price_suffix := "" if price_credits < 0 else " — %d crédits" % price_credits
	return "[E] %s — %s%s" % [action_label, display_name, price_suffix]


func set_interaction_enabled(should_enable: bool) -> void:
	if interaction_enabled == should_enable:
		return
	interaction_enabled = should_enable
	interaction_state_changed.emit()


func on_target_lost() -> void:
	pass
