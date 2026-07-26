extends SceneTree

const HELIX_BLOCKOUT := preload("res://world/helix_blockout.gd")
const START_POSITION := Vector3(0.0, 0.0, 8.0)
const END_POSITION := Vector3(0.0, 0.0, -62.0)


func _initialize() -> void:
	_verify.call_deferred()


func _verify() -> void:
	var world := Node3D.new()
	var blockout := HELIX_BLOCKOUT.new()
	world.add_child(blockout)
	root.add_child(world)
	for _frame in 4:
		await physics_frame

	var navigation_map: RID = world.get_world_3d().navigation_map
	var open_path := NavigationServer3D.map_get_path(
		navigation_map,
		START_POSITION,
		END_POSITION,
		true,
	)
	if not _reaches_destination(open_path):
		_fail(world, "la navigation ouverte n'atteint pas l'extraction")
		return

	blockout.set_all_doors_open(false)
	for _frame in 3:
		await physics_frame
	var closed_path := NavigationServer3D.map_get_path(
		navigation_map,
		START_POSITION,
		END_POSITION,
		true,
	)
	if _reaches_destination(closed_path):
		_fail(world, "la navigation fermée atteint encore l'extraction")
		return

	world.queue_free()
	print("NOX_PROTOCOL_HELIX_NAVIGATION_PASSED")
	quit(0)


func _fail(world: Node, reason: String) -> void:
	world.queue_free()
	push_error(reason)
	quit(1)


func _reaches_destination(path: PackedVector3Array) -> bool:
	return not path.is_empty() and path[-1].distance_to(END_POSITION) < 0.1
