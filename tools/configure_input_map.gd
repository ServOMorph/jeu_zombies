extends SceneTree

const KEY_ACTIONS: Dictionary[String, Key] = {
	"move_forward": KEY_W,
	"move_backward": KEY_S,
	"move_left": KEY_A,
	"move_right": KEY_D,
	"jump": KEY_SPACE,
	"crouch": KEY_CTRL,
	"sprint": KEY_SHIFT,
	"reload": KEY_R,
	"melee": KEY_V,
	"interact": KEY_E,
	"pause": KEY_ESCAPE,
}

const MOUSE_ACTIONS: Dictionary[String, MouseButton] = {
	"fire": MOUSE_BUTTON_LEFT,
	"aim": MOUSE_BUTTON_RIGHT,
	"weapon_next": MOUSE_BUTTON_WHEEL_DOWN,
	"weapon_previous": MOUSE_BUTTON_WHEEL_UP,
}


func _initialize() -> void:
	for action: String in KEY_ACTIONS:
		_save_key_action(action, KEY_ACTIONS[action])
	for action: String in MOUSE_ACTIONS:
		_save_mouse_action(action, MOUSE_ACTIONS[action])

	var save_error: Error = ProjectSettings.save()
	if save_error != OK:
		push_error("Impossible d'enregistrer l'Input Map : %s" % error_string(save_error))
		quit(1)
		return

	print("NOX_PROTOCOL_INPUT_MAP_CONFIGURED")
	quit()


func _save_key_action(action: StringName, physical_keycode: Key) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = physical_keycode
	_save_action(action, event)


func _save_mouse_action(action: StringName, button: MouseButton) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = button
	_save_action(action, event)


func _save_action(action: StringName, event: InputEvent) -> void:
	ProjectSettings.set_setting(
		"input/%s" % action,
		{
			"deadzone": 0.5,
			"events": [event],
		},
	)
