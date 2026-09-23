extends RefCounted

const ZOMBIE_SCENE := preload("res://enemies/zombie_standard.tscn")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var zombie := ZOMBIE_SCENE.instantiate() as ZombieStandard
	if zombie == null:
		return ["la scène ZombieStandard doit être instanciable"]
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(zombie)
	var visual_root := zombie.get_node_or_null("BodyVisual") as Node3D
	if visual_root == null:
		failures.append("BodyVisual doit rester le point d'ancrage du modèle zombie")
	else:
		var model := visual_root.get_node_or_null("MixamoModel") as Node3D
		if model == null:
			failures.append("le modèle Mixamo doit être instancié sous BodyVisual")
		var animation_player := visual_root.find_child("AnimationPlayer", true, false) as AnimationPlayer
		if animation_player == null:
			failures.append("le modèle zombie doit exposer un AnimationPlayer")
		else:
			for animation_name: StringName in [&"mixamo/idle", &"mixamo/run", &"mixamo/attack", &"mixamo/death", &"mixamo/dying", &"mixamo/scream"]:
				if not animation_player.has_animation(animation_name):
					failures.append("le clip Mixamo %s est absent" % animation_name)
	for state: ZombieStandard.State in [
		ZombieStandard.State.INACTIVE,
		ZombieStandard.State.SPAWNING,
		ZombieStandard.State.CHASING,
		ZombieStandard.State.ATTACKING,
		ZombieStandard.State.HURT,
		ZombieStandard.State.DYING,
	]:
		if ZombieStandard._animation_name_for_state(state).is_empty():
			failures.append("l'état zombie %s doit être mappé vers une animation" % state)
	zombie.free()
	return failures
