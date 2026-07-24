extends Control

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


func _ready() -> void:
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

	print("NOX_PROTOCOL_DEV_STARTUP_READY")
