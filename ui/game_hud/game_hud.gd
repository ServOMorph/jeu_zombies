class_name GameHud
extends CanvasLayer

const PURCHASE_FEEDBACK_SECONDS := 2.5
const HEALTH_BAR_BASE_WIDTH := 250.0

@onready var health_label: Label = %HealthLabel
@onready var health_bar: ProgressBar = %HealthBar
@onready var stamina_label: Label = %StaminaLabel
@onready var stamina_bar: ProgressBar = %StaminaBar
@onready var credits_label: Label = %CreditsLabel
@onready var wave_label: Label = %WaveLabel
@onready var objective_label: Label = %ObjectiveLabel
@onready var weapon_label: Label = %WeaponLabel
@onready var ammo_label: Label = %AmmoLabel
@onready var interaction_prompt: Label = %InteractionPrompt
@onready var purchase_feedback: Label = %PurchaseFeedback

var _player: PlayerController
var _wave_manager: WaveManager
var _interaction_controller: InteractionController
var _defense_finale_controller: DefenseFinaleController
var _feedback_remaining := 0.0
var _base_max_health := 100.0


func _ready() -> void:
	GameSession.credits_changed.connect(_on_credits_changed)
	GameSession.purchase_succeeded.connect(_on_purchase_succeeded)
	GameSession.purchase_failed.connect(_on_purchase_failed)
	GameSession.session_started.connect(_on_session_changed)
	GameSession.session_reset.connect(_on_session_changed)
	QuestController.state_changed.connect(_on_quest_state_changed)
	_set_text(objective_label, "Objectif : %s" % QuestController.get_objective_text())
	set_process(false)


func configure(
	player: PlayerController,
	wave_manager: WaveManager,
	interaction_controller: InteractionController,
	defense_finale_controller: DefenseFinaleController = null
) -> void:
	_player = player
	_wave_manager = wave_manager
	_interaction_controller = interaction_controller
	_defense_finale_controller = defense_finale_controller
	_base_max_health = maxf(1.0, _player.max_health)
	_player.vitals.health_changed.connect(_on_health_changed)
	_player.vitals.stamina_changed.connect(_on_stamina_changed)
	_player.weapon_controller.weapon_changed.connect(_on_weapon_changed)
	_player.weapon_controller.ammo_changed.connect(_on_ammo_changed)
	_wave_manager.wave_started.connect(_on_wave_started)
	_wave_manager.waves_completed.connect(_on_waves_completed)
	_interaction_controller.target_changed.connect(_on_interaction_target_changed)
	if _defense_finale_controller != null:
		_defense_finale_controller.countdown_changed.connect(_on_defense_finale_countdown_changed)
	_refresh_current_values()


func _process(delta: float) -> void:
	_feedback_remaining = maxf(0.0, _feedback_remaining - delta)
	if _feedback_remaining > 0.0:
		return
	purchase_feedback.visible = false
	set_process(false)


func _refresh_current_values() -> void:
	if _player == null:
		return
	_on_health_changed(_player.vitals.health, _player.vitals.max_health)
	_on_stamina_changed(_player.vitals.stamina, _player.vitals.max_stamina)
	_on_credits_changed(GameSession.get_credits(), 0)
	_on_weapon_changed(_player.weapon_controller.get_current_weapon_name())
	var ammo: Vector2i = _player.weapon_controller.get_current_ammo()
	_on_ammo_changed(ammo.x, ammo.y)
	if _wave_manager != null:
		_set_text(wave_label, "Vague : %d / %d" % [
			_wave_manager.current_wave_number,
			_wave_manager.wave_definitions.size(),
		])
	if _interaction_controller != null:
		_on_interaction_target_changed(_interaction_controller.get_current_target())
	_set_text(objective_label, "Objectif : %s" % QuestController.get_objective_text())


func _on_health_changed(current_health: float, maximum_health: float) -> void:
	_set_text(health_label, "Santé : %.0f / %.0f" % [current_health, maximum_health])
	_set_bar_value(health_bar, current_health, maximum_health)
	_update_health_bar_width(maximum_health)


func _on_stamina_changed(current_stamina: float, maximum_stamina: float) -> void:
	_set_text(stamina_label, "Endurance : %.0f / %.0f" % [current_stamina, maximum_stamina])
	_set_bar_value(stamina_bar, current_stamina, maximum_stamina)


func _on_credits_changed(current_credits: int, _delta: int) -> void:
	_set_text(credits_label, "Crédits : %d" % current_credits)


func _on_weapon_changed(weapon_name: String) -> void:
	_set_text(weapon_label, "Arme : %s" % weapon_name)


func _on_ammo_changed(magazine: int, reserve: int) -> void:
	_set_text(ammo_label, "Munitions : %d / %d" % [magazine, reserve])


func _on_wave_started(wave_number: int, _definition: WaveDefinition) -> void:
	_set_text(wave_label, "Vague : %d / %d" % [wave_number, _wave_manager.wave_definitions.size()])


func _on_waves_completed() -> void:
	_set_text(wave_label, "Vagues terminées : %d / %d" % [
		_wave_manager.current_wave_number,
		_wave_manager.wave_definitions.size(),
	])


func _on_interaction_target_changed(target) -> void:
	interaction_prompt.visible = target != null
	if target != null:
		_set_text(interaction_prompt, target.get_interaction_prompt())


func _on_purchase_succeeded(item_name: String, cost: int, remaining_credits: int) -> void:
	_show_purchase_feedback("Achat réussi : %s\n-%d crédits — Solde : %d" % [
		item_name,
		cost,
		remaining_credits,
	], Color(0.45, 1.0, 0.58, 1.0))


func _on_purchase_failed(item_name: String, cost: int, available_credits: int) -> void:
	_show_purchase_feedback("Crédits insuffisants : %s\nCoût : %d — Solde : %d" % [
		item_name,
		cost,
		available_credits,
	], Color(1.0, 0.42, 0.32, 1.0))


func _on_session_changed(_value: Variant = null) -> void:
	_on_credits_changed(GameSession.get_credits(), 0)


func _on_quest_state_changed(_previous_state: int, _new_state: int) -> void:
	_set_text(objective_label, "Objectif : %s" % QuestController.get_objective_text())


func _on_defense_finale_countdown_changed(remaining_seconds: float) -> void:
	if QuestController.state != QuestController.State.DEFENSE_FINALE:
		return
	_set_text(objective_label, "Objectif : %s (%d s)" % [
		QuestController.get_objective_text(),
		int(remaining_seconds),
	])


func _show_purchase_feedback(message: String, color: Color) -> void:
	_set_text(purchase_feedback, message)
	if purchase_feedback.modulate != color:
		purchase_feedback.modulate = color
	purchase_feedback.visible = true
	_feedback_remaining = PURCHASE_FEEDBACK_SECONDS
	set_process(true)


func _set_text(label: Label, value: String) -> void:
	if label.text != value:
		label.text = value


func _update_health_bar_width(maximum_health: float) -> void:
	var width := HEALTH_BAR_BASE_WIDTH * (maximum_health / _base_max_health)
	if not is_equal_approx(health_bar.custom_minimum_size.x, width):
		health_bar.custom_minimum_size.x = width


func _set_bar_value(bar: ProgressBar, current_value: float, maximum_value: float) -> void:
	var value := 0.0 if maximum_value <= 0.0 else current_value / maximum_value * 100.0
	if not is_equal_approx(bar.value, value):
		bar.value = value
