extends Node

signal value_changed(key: String, value: float)
signal reset

const SAVE_PATH := "user://port_balance.cfg"
const SECTION := "balance"
const DEFAULTS := {
	"zombie_reward": 50.0,
	"wave_start_count": 40.0,
	"wave_increment": 5.0,
	"health_per_wave": 0.10,
	"spawn_interval": 1.0,
	"final_spawn_speed_bonus": 0.20,
	"extraction_duration": 90.0,
	"weapon_1_price": 500.0,
	"weapon_2_price": 1000.0,
	"weapon_3_price": 1500.0,
	"weapon_4_price": 2000.0,
	"weapon_1_ammo_price": 100.0,
	"weapon_2_ammo_price": 150.0,
	"weapon_3_ammo_price": 200.0,
	"weapon_4_ammo_price": 250.0,
	"mystery_box_price": 1000.0,
	"perk_price": 1000.0,
	"upgrade_price": 1500.0,
	"door_1_price": 500.0,
	"door_2_price": 1000.0,
	"door_3_price": 1500.0,
	"extraction_price": 1000.0,
}

var _values: Dictionary = DEFAULTS.duplicate(true)


func _ready() -> void:
	load_values()


func get_value(key: String) -> float:
	return float(_values.get(key, DEFAULTS.get(key, 0.0)))


func set_value(key: String, value: float) -> bool:
	if not DEFAULTS.has(key):
		return false
	var normalized := maxf(0.0, value)
	if is_equal_approx(get_value(key), normalized):
		return true
	_values[key] = normalized
	_save()
	value_changed.emit(key, normalized)
	return true


func reset_defaults() -> void:
	_values = DEFAULTS.duplicate(true)
	_save()
	reset.emit()


func load_values() -> void:
	_values = DEFAULTS.duplicate(true)
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	for key: String in DEFAULTS:
		_values[key] = maxf(0.0, float(config.get_value(SECTION, key, DEFAULTS[key])))


func _save() -> void:
	var config := ConfigFile.new()
	for key: String in _values:
		config.set_value(SECTION, key, _values[key])
	config.save(SAVE_PATH)
