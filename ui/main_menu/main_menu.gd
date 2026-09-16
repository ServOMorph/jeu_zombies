extends Control

const HELIX_SCENE := "res://world/dev_player_test.tscn"
const PORT_SCENE := "res://world/port_level.tscn"

@onready var port_objective: Label = %PortObjective
@onready var reset_confirmation: ConfirmationDialog = %ResetConfirmation
@onready var port_button: Button = %PortButton


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameSession.return_to_menu()
	port_button.grab_focus()
	port_objective.text = "Objectif sauvegardé : atteindre la manche %d puis s'extraire" % PortProgress.get_target_wave()


func _on_helix_pressed() -> void:
	get_tree().change_scene_to_file(HELIX_SCENE)


func _on_port_pressed() -> void:
	get_tree().change_scene_to_file(PORT_SCENE)


func _on_reset_pressed() -> void:
	reset_confirmation.popup_centered()


func _on_reset_confirmed() -> void:
	PortProgress.reset_progress()
	port_objective.text = "Objectif sauvegardé : atteindre la manche %d puis s'extraire" % PortProgress.get_target_wave()
