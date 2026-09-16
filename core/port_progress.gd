extends Node

const SAVE_PATH := "user://port_progress.cfg"
const SECTION := "port"
const TARGET_KEY := "target_wave"
const DEFAULT_TARGET_WAVE := 3
const MAX_TARGET_WAVE := 10

var _target_wave := DEFAULT_TARGET_WAVE


func _ready() -> void:
	load_progress()


func get_target_wave() -> int:
	return _target_wave


func record_victory() -> int:
	_target_wave = mini(MAX_TARGET_WAVE, _target_wave + 1)
	_save()
	return _target_wave


func reset_progress() -> void:
	_target_wave = DEFAULT_TARGET_WAVE
	_save()


func load_progress() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		_target_wave = DEFAULT_TARGET_WAVE
		return
	_target_wave = clampi(int(config.get_value(SECTION, TARGET_KEY, DEFAULT_TARGET_WAVE)), DEFAULT_TARGET_WAVE, MAX_TARGET_WAVE)


func _save() -> void:
	var config := ConfigFile.new()
	config.set_value(SECTION, TARGET_KEY, _target_wave)
	config.save(SAVE_PATH)
