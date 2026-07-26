class_name InteractionTestTerminal
extends "res://systems/interactable.gd"

@onready var status_label: Label3D = $StatusLabel

var activation_count := 0


func interact(player: Node) -> bool:
	if not super(player):
		return false
	activation_count += 1
	display_name = "Console activée"
	status_label.text = "CONSOLE\nACTIVÉE %d" % activation_count
	interaction_state_changed.emit()
	return true
