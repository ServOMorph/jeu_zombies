extends SceneTree

const IMPORTS_PATH := "res://imports"
var selected_modules: PackedStringArray = [
	"np_kms_03_sol_bord.tscn",
	"np_kms_13_encadrement_simple.tscn",
	"np_kms_14_encadrement_double.tscn",
	"np_kms_20_pilier.tscn",
]


func _init() -> void:
	var output_path := ProjectSettings.globalize_path("res://../kit_modulaire/exports").simplify_path()
	var output_error := DirAccess.make_dir_recursive_absolute(output_path)
	if output_error != OK:
		_fail("Création du dossier d'export impossible : %s" % output_path)
		return
	for source_file: String in selected_modules:
		var resource := load("%s/%s" % [IMPORTS_PATH, source_file])
		if resource is not PackedScene:
			_fail("Scène non chargeable : %s" % source_file)
			return
		var instance := (resource as PackedScene).instantiate()
		var document := GLTFDocument.new()
		var state := GLTFState.new()
		var append_error := document.append_from_scene(instance, state)
		if append_error != OK:
			instance.queue_free()
			_fail("Export GLB impossible : %s" % source_file)
			return
		var output_file := output_path.path_join("%s.glb" % source_file.get_basename())
		var write_error := document.write_to_filesystem(state, output_file)
		instance.queue_free()
		if write_error != OK:
			_fail("Écriture GLB impossible : %s" % output_file)
			return
	print("NOX_PROTOCOL_SELECTED_KIT_GLB_EXPORT_READY count=%d" % selected_modules.size())
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
