extends RefCounted

const DEV_PLAYER_TEST := preload("res://world/dev_player_test.tscn")
const INTERACTABLE := preload("res://systems/interactable.gd")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	GameSession.return_to_menu()
	var world := DEV_PLAYER_TEST.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(world)
	var hud := world.get_node_or_null("GameHud") as CanvasLayer
	if hud == null:
		failures.append("la scène doit contenir un HUD autonome")
		world.queue_free()
		return failures
	var credits_label := hud.get_node("CreditsLabel") as Label
	var health_label := hud.get_node("VitalsPanel/HealthLabel") as Label
	var stamina_label := hud.get_node("VitalsPanel/StaminaLabel") as Label
	var weapon_label := hud.get_node("WeaponPanel/WeaponLabel") as Label
	var ammo_label := hud.get_node("WeaponPanel/AmmoLabel") as Label
	var wave_label := hud.get_node("WaveLabel") as Label
	if not GameSession.start_new_session() or not GameSession.add_credits(150):
		failures.append("le HUD doit pouvoir recevoir les crédits de session")
	if credits_label.text != "Crédits : 150":
		failures.append("le HUD doit afficher le solde de crédits réel")
	world.player.vitals.apply_damage(25.0)
	if health_label.text != "Santé : 75 / 100":
		failures.append("le HUD doit suivre la santé par signal")
	world.player.vitals.stamina = 60.0
	world.player.vitals.stamina_changed.emit(60.0, 100.0)
	if stamina_label.text != "Endurance : 60 / 100":
		failures.append("le HUD doit suivre l'endurance par signal")
	world.player.weapon_controller.weapon_changed.emit("Couteau")
	world.player.weapon_controller.ammo_changed.emit(0, 0)
	if weapon_label.text != "Arme : Couteau" or ammo_label.text != "Munitions : 0 / 0":
		failures.append("le HUD doit suivre l'arme et les munitions par signaux")
	world.wave_manager.current_wave_number = 2
	world.wave_manager.wave_started.emit(2, world.wave_manager.wave_definitions[1])
	if wave_label.text != "Vague : 2 / 5":
		failures.append("le HUD doit afficher la vague réelle")
	var interactable = INTERACTABLE.new()
	interactable.action_label = "Ouvrir"
	interactable.display_name = "Porte nord"
	interactable.price_credits = 100
	world.interaction_controller.target_changed.emit(interactable)
	var interaction_prompt := hud.get_node("InteractionPrompt") as Label
	if not interaction_prompt.visible or interaction_prompt.text != "[E] Ouvrir — Porte nord — 100 crédits":
		failures.append("le HUD doit afficher l'invite contextuelle")
	if interaction_prompt.anchor_top != 1.0 or interaction_prompt.anchor_bottom != 1.0:
		failures.append("l'invite du HUD doit être ancrée en bas de l'écran")
	interactable.free()
	world.queue_free()
	GameSession.return_to_menu()
	return failures
