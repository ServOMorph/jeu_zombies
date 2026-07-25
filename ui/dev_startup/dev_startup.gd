extends Control

const DEV_METRICS_OVERLAY := preload(
	"res://ui/dev_overlay/dev_metrics_overlay.tscn"
)
const EXPECTED_INPUT_ACTIONS: PackedStringArray = [
	"move_forward",
	"move_backward",
	"move_left",
	"move_right",
	"jump",
	"crouch",
	"sprint",
	"fire",
	"aim",
	"reload",
	"melee",
	"interact",
	"weapon_next",
	"weapon_previous",
	"pause",
]

@onready var session_status: Label = %SessionStatus


func _ready() -> void:
	if OS.is_debug_build():
		add_child(DEV_METRICS_OVERLAY.instantiate())

	var missing_actions: PackedStringArray = []
	for action: String in EXPECTED_INPUT_ACTIONS:
		if (
			not InputMap.has_action(action)
			or InputMap.action_get_events(action).is_empty()
		):
			missing_actions.append(action)

	if not missing_actions.is_empty():
		push_error(
			"Actions d'entrée absentes ou non assignées : %s"
			% ", ".join(missing_actions)
		)
		return

	GameSession.session_started.connect(_on_session_changed)
	GameSession.session_paused.connect(_on_session_changed)
	GameSession.session_ended.connect(_on_session_changed)
	GameSession.session_reset.connect(_on_session_changed)
	_update_session_status()

	print("NOX_PROTOCOL_DEV_STARTUP_READY")


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return

	if event.keycode == KEY_ENTER:
		GameSession.start_new_session()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_P:
		GameSession.toggle_pause()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_ESCAPE:
		GameSession.return_to_menu()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_F2 and GameSession.state == GameSession.State.PLAYING:
		get_viewport().set_input_as_handled()
		get_tree().change_scene_to_file("res://world/dev_player_test.tscn")


func _on_session_changed(_value: Variant = null) -> void:
	_update_session_status()


func _update_session_status() -> void:
	var state_names := {
		GameSession.State.MENU: "MENU",
		GameSession.State.PLAYING: "PARTIE EN COURS",
		GameSession.State.PAUSED: "PAUSE",
		GameSession.State.DEFEAT: "DÉFAITE",
		GameSession.State.VICTORY: "VICTOIRE",
	}
	session_status.text = "État de session : %s" % state_names[GameSession.state]
