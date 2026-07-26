extends RefCounted

const PLAYER_PERKS := preload("res://player/player_perks.gd")
const PLAYER := preload("res://player/player.tscn")
const PERK_CONSTITUTION := preload("res://data/perks/perk_constitution_renforcee.tres")
const PERK_GESTES_PRECIS := preload("res://data/perks/perk_gestes_precis.tres")
const PERK_REFLEXES := preload("res://data/perks/perk_reflexes_stimules.tres")
const PERK_REPARATION := preload("res://data/perks/perk_reparation_cellulaire.tres")


func run_tests() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_test_purchase_flow())
	failures.append_array(_test_player_effects())
	GameSession.return_to_menu()
	return failures


func _test_purchase_flow() -> Array[String]:
	var failures: Array[String] = []
	GameSession.return_to_menu()
	GameSession.start_new_session()

	var perks := PLAYER_PERKS.new()
	if perks.try_purchase(PERK_CONSTITUTION):
		failures.append("l'achat sans crédits suffisants doit être refusé")
	if GameSession.get_credits() != 0:
		failures.append("un achat refusé ne doit pas modifier les crédits")

	GameSession.add_credits(PERK_CONSTITUTION.price_credits)
	if not perks.try_purchase(PERK_CONSTITUTION):
		failures.append("l'achat avec assez de crédits doit réussir")
	if not perks.is_owned(PERK_CONSTITUTION.perk_id):
		failures.append("l'avantage acheté doit être marqué possédé")
	if GameSession.get_credits() != 0:
		failures.append("l'achat doit débiter exactement son prix une seule fois")

	GameSession.add_credits(PERK_CONSTITUTION.price_credits)
	if perks.try_purchase(PERK_CONSTITUTION):
		failures.append("un second achat du même avantage doit être refusé")
	if GameSession.get_credits() != PERK_CONSTITUTION.price_credits:
		failures.append("un second achat refusé ne doit pas débiter de crédits")

	if not is_equal_approx(
		perks.get_effect_multiplier(PerkDefinition.Effect.HEALTH),
		PERK_CONSTITUTION.effect_multiplier
	):
		failures.append("le multiplicateur de santé doit refléter l'avantage possédé")
	if not is_equal_approx(perks.get_effect_multiplier(PerkDefinition.Effect.MOVEMENT_SPEED), 1.0):
		failures.append("un effet non possédé doit rester neutre")
	return failures


func _test_player_effects() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	GameSession.return_to_menu()

	var player := PLAYER.instantiate()
	tree.root.add_child(player)
	var base_max_health: float = player.max_health
	var base_regeneration: float = player.health_regeneration_per_second

	player.receive_damage(20.0)
	GameSession.start_new_session()
	GameSession.add_credits(4000)

	if not player.perks.try_purchase(PERK_CONSTITUTION):
		failures.append("l'achat de Constitution renforcée doit réussir")
	var expected_max_health: float = base_max_health * PERK_CONSTITUTION.effect_multiplier
	if not is_equal_approx(player.vitals.max_health, expected_max_health):
		failures.append("la santé maximale doit augmenter du multiplicateur de l'avantage")
	if player.vitals.health <= base_max_health - 20.0:
		failures.append("le gain de santé maximale doit soigner le joueur d'autant")

	if not player.perks.try_purchase(PERK_REPARATION):
		failures.append("l'achat de Réparation cellulaire doit réussir")
	var expected_regeneration: float = base_regeneration * PERK_REPARATION.effect_multiplier
	if not is_equal_approx(player.vitals.health_regeneration_per_second, expected_regeneration):
		failures.append("la régénération doit augmenter du multiplicateur de l'avantage")

	if not player.perks.try_purchase(PERK_REFLEXES):
		failures.append("l'achat de Réflexes stimulés doit réussir")
	if not is_equal_approx(player._movement_speed_multiplier, PERK_REFLEXES.effect_multiplier):
		failures.append("la vitesse de déplacement doit augmenter du multiplicateur de l'avantage")

	if not player.perks.try_purchase(PERK_GESTES_PRECIS):
		failures.append("l'achat de Gestes précis doit réussir")
	if not is_equal_approx(
		player.weapon_controller.reload_speed_multiplier, PERK_GESTES_PRECIS.effect_multiplier
	):
		failures.append("le rechargement doit accélérer du multiplicateur de l'avantage")

	player.free()
	return failures
