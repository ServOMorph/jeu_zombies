extends Node3D

const STARTUP_SCENE := "res://ui/dev_startup/dev_startup.tscn"

@onready var player = $Player
@onready var vitals_label: Label = %VitalsLabel
@onready var weapon_label: Label = %WeaponLabel
@onready var target = $TargetDummy


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("NOX_PROTOCOL_DEV_PLAYER_TEST_READY")


func _process(_delta: float) -> void:
	var state := "DÉFAITE" if player.vitals.is_dead else "EN COURS"
	var sprint_state := "ACTIVE" if player.is_sprinting else "REPOS"
	if player.vitals.is_exhausted:
		sprint_state = "ÉPUISÉ"
	vitals_label.text = "Santé : %.0f / %.0f\nEndurance : %.0f / %.0f\nVitesse : %.1f m/s\nCourse : %s\nÉtat : %s" % [
		player.vitals.health,
		player.vitals.max_health,
		player.vitals.stamina,
		player.vitals.max_stamina,
		player.get_horizontal_speed(),
		sprint_state,
		state,
	]
	var ammo: Vector2i = player.weapon_controller.get_current_ammo()
	weapon_label.text = "Arme : %s\nMunitions : %d / %d\nCible : %.0f / %.0f" % [
		player.weapon_controller.get_current_weapon_name(),
		ammo.x,
		ammo.y,
		target.health,
		target.max_health,
	]


func _input(event: InputEvent) -> void:
	if (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_ESCAPE
	):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		GameSession.return_to_menu()
		get_tree().change_scene_to_file(STARTUP_SCENE)
		get_viewport().set_input_as_handled()
	elif (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F6
	):
		player.receive_damage(25.0)
		get_viewport().set_input_as_handled()
	elif (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F7
	):
		target.reset()
		get_viewport().set_input_as_handled()
