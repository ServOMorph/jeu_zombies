extends RefCounted

const MODEL := preload("res://assets/characters/enemies/mixamo/zombie_model.fbx")
const IDLE := preload("res://assets/characters/enemies/mixamo/zombie idle.fbx")
const WALK := preload("res://assets/characters/enemies/mixamo/zombie walk.fbx")
const RUN := preload("res://assets/characters/enemies/mixamo/zombie run.fbx")
const ATTACK := preload("res://assets/characters/enemies/mixamo/zombie attack.fbx")
const DEATH := preload("res://assets/characters/enemies/mixamo/zombie death.fbx")
const DYING := preload("res://assets/characters/enemies/mixamo/zombie dying.fbx")
const SCREAM := preload("res://assets/characters/enemies/mixamo/zombie scream.fbx")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var model := MODEL.instantiate() as Node3D
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(model)
	var bounds := AABB()
	var has_mesh := false
	for node: Node in model.find_children("*", "MeshInstance3D", true, false):
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh == null:
			continue
		var mesh_bounds := mesh_instance.global_transform * mesh_instance.mesh.get_aabb()
		bounds = mesh_bounds if not has_mesh else bounds.merge(mesh_bounds)
		has_mesh = true
	if not has_mesh or absf(bounds.position.y) > 0.05:
		failures.append("le pivot du modèle Mixamo doit rester au niveau du sol")
	model.queue_free()
	for source: PackedScene in [MODEL, IDLE, WALK, RUN, ATTACK, DEATH, DYING, SCREAM]:
		var instance := source.instantiate() as Node3D
		if instance == null:
			failures.append("un FBX Mixamo doit être instanciable")
			continue
		var skeleton := instance.find_child("Skeleton3D", true, false) as Skeleton3D
		var animation_player := instance.find_child("AnimationPlayer", true, false) as AnimationPlayer
		if skeleton == null:
			failures.append("un FBX Mixamo doit contenir un Skeleton3D")
		if animation_player == null:
			failures.append("un FBX Mixamo doit contenir un AnimationPlayer")
		elif animation_player.get_animation(&"mixamo_com") == null:
			failures.append("un FBX Mixamo doit contenir son clip mixamo_com")
		else:
			var configured := animation_player.get_animation(&"mixamo_com").duplicate(true) as Animation
			ZombieStandard.configure_mixamo_animation(&"run", configured)
			if configured.loop_mode != Animation.LOOP_LINEAR:
				failures.append("les animations de déplacement Mixamo doivent boucler")
			for index in configured.get_track_count():
				if not ZombieStandard.is_mixamo_root_translation_track(configured.track_get_path(index), configured.track_get_type(index)):
					continue
				var initial_position := configured.track_get_key_value(index, 0) as Vector3
				for key_index in configured.track_get_key_count(index):
					var position := configured.track_get_key_value(index, key_index) as Vector3
					if not is_equal_approx(position.x, initial_position.x) or not is_equal_approx(position.z, initial_position.z):
						failures.append("la translation horizontale du bassin Mixamo doit être neutralisée")
		instance.free()
	return failures
