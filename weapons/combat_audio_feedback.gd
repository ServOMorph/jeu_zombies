class_name CombatAudioFeedback
extends Node

const MIX_RATE := 44100

var _players: Dictionary = {}


func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
	_register_tone("shot", 160.0, 0.09, 0.18)
	_register_tone("hit", 720.0, 0.05, 0.10)
	_register_tone("melee", 95.0, 0.12, 0.14)


func play_shot() -> void:
	_play_tone("shot")


func play_weapon_shot(weapon_name: String, frequency: float, duration_seconds: float, amplitude: float) -> void:
	if DisplayServer.get_name() == "headless":
		return
	var key := "weapon:%s" % weapon_name
	if not _players.has(key):
		_register_tone(key, frequency, duration_seconds, amplitude)
	_play_tone(key)


func play_hit() -> void:
	_play_tone("hit")


func play_melee() -> void:
	_play_tone("melee")


static func create_tone_stream(
	frequency: float,
	duration_seconds: float,
	amplitude: float
) -> AudioStreamWAV:
	var sample_count := maxi(1, int(round(duration_seconds * MIX_RATE)))
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	for sample_index in sample_count:
		var progress := float(sample_index) / float(sample_count)
		var envelope := (1.0 - progress) * (1.0 - progress)
		var phase := float(sample_index) * frequency / float(MIX_RATE)
		var sample := sin(phase * TAU) * amplitude * envelope
		data.encode_s16(sample_index * 2, int(round(clampf(sample, -1.0, 1.0) * 32767.0)))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	stream.stereo = false
	stream.data = data
	return stream


func _register_tone(name: String, frequency: float, duration_seconds: float, amplitude: float) -> void:
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = create_tone_stream(frequency, duration_seconds, amplitude)
	audio_player.volume_db = -12.0
	add_child(audio_player)
	_players[name] = audio_player


func _play_tone(name: String) -> void:
	var audio_player := _players.get(name) as AudioStreamPlayer
	if audio_player != null:
		audio_player.play()
