extends RefCounted

const INTERACTABLE := preload("res://systems/interactable.gd")
const INTERACTION_CONTROLLER := preload("res://systems/interaction_controller.gd")
const PLAYER_SCENE := preload("res://player/player.tscn")
const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	var player := PLAYER_SCENE.instantiate()
	var interaction_probe := player.get_node(
		"Head/Camera3D/InteractionController/InteractionProbe"
	) as RayCast3D
	if not interaction_probe.get_parent() is Node3D:
		failures.append("la sonde doit hériter de la transformation 3D de la caméra")
	if not interaction_probe.collide_with_areas or interaction_probe.collision_mask != 2:
		failures.append("la sonde doit détecter les zones d'interaction de la couche 2")
	player.free()
	var world := DEV_PLAYER_TEST.instantiate()
	var interaction_prompt := world.get_node("GameHud/InteractionPrompt") as Label
	if interaction_prompt.anchor_top != 1.0 or interaction_prompt.anchor_bottom != 1.0:
		failures.append("l'invite d'interaction doit être ancrée en bas de l'écran")
	if interaction_prompt.offset_top >= interaction_prompt.offset_bottom:
		failures.append("l'invite d'interaction doit avoir une hauteur visible")
	var purchase_feedback := world.get_node_or_null("GameHud/PurchaseFeedback") as Label
	if purchase_feedback == null or purchase_feedback.visible:
		failures.append("le feedback d'achat dédié doit exister et être masqué au repos")
	world.free()
	var interactable = INTERACTABLE.new()
	interactable.action_label = "Ouvrir"
	interactable.display_name = "Porte nord"
	interactable.price_credits = 750
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(interactable)
	if interactable.get_interaction_prompt() != "[E] Ouvrir — Porte nord — 750 crédits":
		failures.append("l'invite doit afficher action, nom et prix")
	if not interactable.interact(null):
		failures.append("une cible valide doit pouvoir être activée")
	interactable.set_interaction_enabled(false)
	if interactable.can_interact(null):
		failures.append("une cible désactivée ne doit plus être valide")
	if INTERACTION_CONTROLLER.should_activate(false, false):
		failures.append("une touche relâchée ne doit pas activer la cible")
	if not INTERACTION_CONTROLLER.should_activate(true, false):
		failures.append("le premier appui doit activer la cible")
	if INTERACTION_CONTROLLER.should_activate(true, true):
		failures.append("un appui maintenu ne doit pas réactiver la cible")
	interactable.free()
	return failures
