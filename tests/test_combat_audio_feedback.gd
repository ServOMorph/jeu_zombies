extends RefCounted

const COMBAT_AUDIO_FEEDBACK := preload("res://weapons/combat_audio_feedback.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var stream := COMBAT_AUDIO_FEEDBACK.create_tone_stream(160.0, 0.1, 0.2)
	if stream.format != AudioStreamWAV.FORMAT_16_BITS:
		failures.append("le son synthétisé doit utiliser le format 16 bits")
	if stream.mix_rate != 44100:
		failures.append("le son synthétisé doit utiliser la fréquence attendue")
	if stream.data.size() != 8820:
		failures.append("la durée du son synthétisé doit correspondre au nombre d'échantillons")
	return failures
