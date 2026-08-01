extends SceneTree

var materials: Dictionary[String, StandardMaterial3D] = {}


func _init() -> void:
	_create_materials()
	var zombie := _build_zombie()
	var output_path := ProjectSettings.globalize_path("res://exports")
	if DirAccess.make_dir_recursive_absolute(output_path) != OK:
		_fail("Création du dossier d’export impossible")
		return
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	if document.append_from_scene(zombie, state) != OK:
		_fail("Conversion GLTF impossible")
		return
	var output_file := output_path.path_join("np_z04_zombie_standard.glb")
	if document.write_to_filesystem(state, output_file) != OK:
		_fail("Écriture GLB impossible")
		return
	zombie.queue_free()
	print("NOX_PROTOCOL_PHASE4_GLB_EXPORT_READY animations=8")
	quit(0)


func _create_materials() -> void:
	materials["skin"] = _material(Color("#9da79a"), 0.84)
	materials["jacket"] = _material(Color("#242b31"), 0.78)
	materials["undershirt"] = _material(Color("#485866"), 0.82)
	materials["amber"] = _material(Color("#e6a33b"), 0.52, 0.04)


func _material(color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	return material


func _build_zombie() -> Node3D:
	var root := Node3D.new()
	root.name = "NP_Z04_ZOM_01_Standard"
	var skeleton := _create_skeleton()
	root.add_child(skeleton)
	_add_skinned_torso(skeleton)
	var rig := Node3D.new()
	rig.name = "VisualRig"
	root.add_child(rig)

	var hips := _joint(rig, "Hips", Vector3(0.0, 1.02, 0.0), Vector3(0.0, deg_to_rad(-7.0), 0.0))
	_add_box(hips, "Bassin", Vector3(0.44, 0.23, 0.29), Vector3(0.0, 0.0, 0.0), materials["jacket"])
	var spine := _joint(hips, "Spine", Vector3(0.0, 0.20, 0.01))
	_add_box(spine, "VesteBas", Vector3(0.52, 0.37, 0.31), Vector3(0.0, 0.15, 0.0), materials["jacket"])
	var chest := _joint(spine, "Chest", Vector3(0.0, 0.31, -0.03), Vector3(deg_to_rad(8.0), 0.0, 0.0))
	_add_box(chest, "VesteHaut", Vector3(0.61, 0.40, 0.34), Vector3(0.0, 0.16, 0.0), materials["jacket"])
	_add_box(chest, "SousCouche", Vector3(0.28, 0.32, 0.025), Vector3(0.0, 0.15, -0.183), materials["undershirt"])
	var neck := _joint(chest, "Neck", Vector3(0.0, 0.39, 0.03), Vector3(deg_to_rad(10.0), 0.0, 0.0))
	_add_cylinder(neck, "Cou", 0.11, 0.18, Vector3(0.0, 0.04, 0.0), materials["skin"])
	var head := _joint(neck, "Head", Vector3(0.0, 0.15, -0.07), Vector3(deg_to_rad(12.0), 0.0, 0.0))
	_add_head(head)
	_build_arm(chest, "L", -1.0, true)
	_build_arm(chest, "R", 1.0, false)
	_build_leg(hips, "L", -1.0)
	_build_leg(hips, "R", 1.0)
	_add_animation_player(root)
	return root


func _create_skeleton() -> Skeleton3D:
	var skeleton := Skeleton3D.new()
	skeleton.name = "Skeleton3D"
	var bones := [
		"Hips", "Spine", "Chest", "Neck", "Head", "UpperArm_L", "LowerArm_L", "Hand_L",
		"UpperArm_R", "LowerArm_R", "Hand_R", "UpperLeg_L", "LowerLeg_L", "Foot_L", "Toe_L",
		"UpperLeg_R", "LowerLeg_R", "Foot_R", "Toe_R"
	]
	for bone_name: String in bones:
		skeleton.add_bone(bone_name)
	var parents := {
		"Spine": "Hips", "Chest": "Spine", "Neck": "Chest", "Head": "Neck",
		"UpperArm_L": "Chest", "LowerArm_L": "UpperArm_L", "Hand_L": "LowerArm_L",
		"UpperArm_R": "Chest", "LowerArm_R": "UpperArm_R", "Hand_R": "LowerArm_R",
		"UpperLeg_L": "Hips", "LowerLeg_L": "UpperLeg_L", "Foot_L": "LowerLeg_L", "Toe_L": "Foot_L",
		"UpperLeg_R": "Hips", "LowerLeg_R": "UpperLeg_R", "Foot_R": "LowerLeg_R", "Toe_R": "Foot_R"
	}
	for bone_name: String in parents:
		skeleton.set_bone_parent(skeleton.find_bone(bone_name), skeleton.find_bone(parents[bone_name]))
	for bone_index: int in skeleton.get_bone_count():
		skeleton.set_bone_rest(bone_index, Transform3D.IDENTITY)
	return skeleton


func _add_skinned_torso(skeleton: Skeleton3D) -> void:
	var instance := MeshInstance3D.new()
	instance.name = "SkinnedTorso"
	instance.mesh = _make_skinned_box(Vector3(0.58, 1.12, 0.34), Vector3(0.0, 1.48, 0.0), skeleton.find_bone("Chest"))
	var skin := Skin.new()
	for bone_index: int in skeleton.get_bone_count():
		skin.add_bind(bone_index, Transform3D.IDENTITY)
	instance.skin = skin
	instance.skeleton = NodePath("..")
	skeleton.add_child(instance)


func _make_skinned_box(size: Vector3, center: Vector3, bone_index: int) -> ArrayMesh:
	var half := size * 0.5
	var vertices := PackedVector3Array([
		center + Vector3(-half.x, -half.y, -half.z), center + Vector3(half.x, -half.y, -half.z),
		center + Vector3(half.x, half.y, -half.z), center + Vector3(-half.x, half.y, -half.z),
		center + Vector3(-half.x, -half.y, half.z), center + Vector3(half.x, -half.y, half.z),
		center + Vector3(half.x, half.y, half.z), center + Vector3(-half.x, half.y, half.z)
	])
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	var bones := PackedInt32Array()
	var weights := PackedFloat32Array()
	for _vertex: int in vertices.size():
		bones.append_array(PackedInt32Array([bone_index, 0, 0, 0]))
		weights.append_array(PackedFloat32Array([1.0, 0.0, 0.0, 0.0]))
	arrays[Mesh.ARRAY_BONES] = bones
	arrays[Mesh.ARRAY_WEIGHTS] = weights
	arrays[Mesh.ARRAY_INDEX] = PackedInt32Array([0, 2, 1, 0, 3, 2, 4, 5, 6, 4, 6, 7, 0, 1, 5, 0, 5, 4, 2, 3, 7, 2, 7, 6, 0, 4, 7, 0, 7, 3, 1, 2, 6, 1, 6, 5])
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh.surface_set_material(0, materials["jacket"])
	return mesh


func _joint(parent: Node3D, joint_name: String, position: Vector3, rotation: Vector3 = Vector3.ZERO) -> Node3D:
	var joint := Node3D.new()
	joint.name = joint_name
	joint.position = position
	joint.rotation = rotation
	parent.add_child(joint)
	return joint


func _build_arm(chest: Node3D, side: String, direction: float, torn: bool) -> void:
	var upper := _joint(chest, "UpperArm_%s" % side, Vector3(0.37 * direction, 0.28, 0.0), Vector3(deg_to_rad(-8.0), 0.0, deg_to_rad(9.0 * direction)))
	_add_box(upper, "BrasHaut_%s" % side, Vector3(0.19, 0.39, 0.20), Vector3(0.0, -0.18, 0.0), materials["jacket"])
	var lower := _joint(upper, "LowerArm_%s" % side, Vector3(0.0, -0.38, 0.0), Vector3(deg_to_rad(-7.0), 0.0, deg_to_rad(3.0 * direction)))
	_add_box(lower, "AvantBras_%s" % side, Vector3(0.16, 0.35, 0.17), Vector3(0.0, -0.16, 0.0), materials["skin"] if torn else materials["jacket"])
	if torn:
		_add_box(lower, "MancheDechiree", Vector3(0.22, 0.06, 0.21), Vector3(0.0, -0.01, 0.0), materials["jacket"])
	var hand := _joint(lower, "Hand_%s" % side, Vector3(0.0, -0.35, -0.01), Vector3(deg_to_rad(-5.0), 0.0, 0.0))
	_add_box(hand, "Main_%s" % side, Vector3(0.17, 0.18, 0.11), Vector3(0.0, -0.07, -0.02), materials["skin"])
	if side == "L":
		_add_box(hand, "BraceletMedical", Vector3(0.20, 0.05, 0.14), Vector3(0.0, 0.04, 0.0), materials["amber"])


func _build_leg(hips: Node3D, side: String, direction: float) -> void:
	var upper := _joint(hips, "UpperLeg_%s" % side, Vector3(0.19 * direction, -0.10, 0.0), Vector3(deg_to_rad(4.0), 0.0, deg_to_rad(2.0 * direction)))
	_add_box(upper, "Cuisse_%s" % side, Vector3(0.25, 0.53, 0.26), Vector3(0.0, -0.26, 0.0), materials["jacket"])
	var lower := _joint(upper, "LowerLeg_%s" % side, Vector3(0.0, -0.52, 0.0), Vector3(deg_to_rad(-4.0), 0.0, 0.0))
	_add_box(lower, "Jambe_%s" % side, Vector3(0.20, 0.47, 0.22), Vector3(0.0, -0.23, 0.0), materials["jacket"])
	var foot := _joint(lower, "Foot_%s" % side, Vector3(0.0, -0.47, -0.03), Vector3(deg_to_rad(5.0), 0.0, 0.0))
	_add_box(foot, "Botte_%s" % side, Vector3(0.23, 0.16, 0.37), Vector3(0.0, -0.06, -0.10), materials["jacket"])
	var toe := _joint(foot, "Toe_%s" % side, Vector3(0.0, -0.03, -0.24))
	_add_box(toe, "Pointe_%s" % side, Vector3(0.22, 0.11, 0.14), Vector3(0.0, -0.01, -0.04), materials["jacket"])


func _add_head(parent: Node3D) -> void:
	var instance := MeshInstance3D.new()
	instance.name = "Tete"
	var mesh := SphereMesh.new()
	mesh.radius = 0.19
	mesh.height = 0.34
	mesh.radial_segments = 8
	mesh.rings = 4
	mesh.material = materials["skin"]
	instance.mesh = mesh
	instance.position = Vector3(0.0, 0.14, -0.04)
	parent.add_child(instance)
	_add_box(parent, "Machoire", Vector3(0.18, 0.10, 0.17), Vector3(0.0, 0.01, -0.14), materials["skin"])


func _add_box(parent: Node3D, node_name: String, size: Vector3, position: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = material
	instance.mesh = mesh
	instance.position = position
	parent.add_child(instance)


func _add_cylinder(parent: Node3D, node_name: String, radius: float, height: float, position: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 8
	mesh.rings = 1
	mesh.material = material
	instance.mesh = mesh
	instance.position = position
	parent.add_child(instance)


func _add_animation_player(root: Node3D) -> void:
	var player := AnimationPlayer.new()
	player.name = "AnimationPlayer"
	root.add_child(player)
	var library := AnimationLibrary.new()
	library.add_animation("spawn", _make_animation(0.8, false, 12.0, 0.0, 0.0))
	library.add_animation("idle", _make_animation(2.4, true, 8.0, 5.0, 3.0))
	library.add_animation("walk", _make_animation(1.0, true, 12.0, 18.0, 8.0))
	library.add_animation("chase", _make_animation(0.72, true, 18.0, 28.0, 12.0))
	library.add_animation("attack", _make_animation(0.55, false, 9.0, 42.0, 14.0))
	library.add_animation("hit_reaction", _make_animation(0.32, false, 16.0, 6.0, 5.0))
	library.add_animation("death", _make_animation(1.10, false, 40.0, 12.0, 8.0))
	library.add_animation("disable", _make_animation(0.45, false, 20.0, 4.0, 3.0))
	player.add_animation_library("", library)


func _make_animation(length: float, looping: bool, chest_angle: float, arm_angle: float, leg_angle: float) -> Animation:
	var animation := Animation.new()
	animation.length = length
	animation.loop_mode = Animation.LOOP_LINEAR if looping else Animation.LOOP_NONE
	_add_rotation_track(animation, "VisualRig/Hips/Spine/Chest", length, Vector3(deg_to_rad(8.0), 0.0, 0.0), Vector3(deg_to_rad(8.0 + chest_angle), 0.0, 0.0), looping)
	_add_rotation_track(animation, "VisualRig/Hips/Spine/Chest/UpperArm_L", length, Vector3(0.0, 0.0, deg_to_rad(-9.0)), Vector3(deg_to_rad(-arm_angle), 0.0, deg_to_rad(-9.0)), looping)
	_add_rotation_track(animation, "VisualRig/Hips/Spine/Chest/UpperArm_R", length, Vector3(0.0, 0.0, deg_to_rad(9.0)), Vector3(deg_to_rad(arm_angle), 0.0, deg_to_rad(9.0)), looping)
	_add_rotation_track(animation, "VisualRig/Hips/UpperLeg_L", length, Vector3.ZERO, Vector3(deg_to_rad(leg_angle), 0.0, 0.0), looping)
	_add_rotation_track(animation, "VisualRig/Hips/UpperLeg_R", length, Vector3.ZERO, Vector3(deg_to_rad(-leg_angle), 0.0, 0.0), looping)
	_add_rotation_track(animation, "Skeleton3D:Chest", length, Vector3.ZERO, Vector3(deg_to_rad(chest_angle), 0.0, 0.0), looping)
	return animation


func _add_rotation_track(animation: Animation, path: String, length: float, start: Vector3, peak: Vector3, looping: bool) -> void:
	var track := animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(track, NodePath(path))
	animation.track_insert_key(track, 0.0, Quaternion.from_euler(start))
	animation.track_insert_key(track, length * 0.5, Quaternion.from_euler(peak))
	animation.track_insert_key(track, length, Quaternion.from_euler(start if looping else Vector3.ZERO))


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
