class_name PlayerVitals
extends RefCounted

signal health_changed(current_health: float, maximum_health: float)
signal stamina_changed(current_stamina: float, maximum_stamina: float)
signal died

var max_health := 100.0
var health := 100.0
var damage_invulnerability_seconds := 0.2
var health_regeneration_delay_seconds := 4.0
var health_regeneration_per_second := 10.0

var max_stamina := 100.0
var stamina := 100.0
var stamina_drain_per_second := 35.0
var stamina_regeneration_per_second := 28.0
var stamina_reactivation_threshold := 25.0

var is_dead := false
var is_exhausted := false
var _invulnerability_remaining := 0.0
var _time_since_last_damage := 0.0


func configure(
	maximum_health: float,
	invulnerability_seconds: float,
	regeneration_delay_seconds: float,
	regeneration_per_second: float,
	maximum_stamina: float,
	drain_per_second: float,
	stamina_regeneration: float,
	reactivation_threshold: float
) -> void:
	max_health = maximum_health
	damage_invulnerability_seconds = invulnerability_seconds
	health_regeneration_delay_seconds = regeneration_delay_seconds
	health_regeneration_per_second = regeneration_per_second
	max_stamina = maximum_stamina
	stamina_drain_per_second = drain_per_second
	stamina_regeneration_per_second = stamina_regeneration
	stamina_reactivation_threshold = reactivation_threshold
	reset()


func reset() -> void:
	health = max_health
	stamina = max_stamina
	is_dead = false
	is_exhausted = false
	_invulnerability_remaining = 0.0
	_time_since_last_damage = 0.0
	health_changed.emit(health, max_health)
	stamina_changed.emit(stamina, max_stamina)


func apply_damage(amount: float) -> bool:
	if is_dead or amount <= 0.0 or _invulnerability_remaining > 0.0:
		return false

	health = maxf(0.0, health - amount)
	_invulnerability_remaining = damage_invulnerability_seconds
	_time_since_last_damage = 0.0
	health_changed.emit(health, max_health)
	if health == 0.0:
		is_dead = true
		died.emit()
	return true


func update(delta: float, is_sprinting: bool) -> void:
	if is_dead:
		return

	_invulnerability_remaining = maxf(0.0, _invulnerability_remaining - delta)
	_time_since_last_damage += delta
	_update_health_regeneration(delta)
	_update_stamina(delta, is_sprinting)


func can_sprint() -> bool:
	return not is_dead and not is_exhausted and stamina > 0.0


func _update_health_regeneration(delta: float) -> void:
	if health >= max_health or _time_since_last_damage < health_regeneration_delay_seconds:
		return

	var previous_health := health
	health = minf(max_health, health + health_regeneration_per_second * delta)
	if health != previous_health:
		health_changed.emit(health, max_health)


func _update_stamina(delta: float, is_sprinting: bool) -> void:
	var previous_stamina := stamina
	if is_sprinting and can_sprint():
		stamina = maxf(0.0, stamina - stamina_drain_per_second * delta)
		if stamina == 0.0:
			is_exhausted = true
	else:
		stamina = minf(max_stamina, stamina + stamina_regeneration_per_second * delta)
		if is_exhausted and stamina >= stamina_reactivation_threshold:
			is_exhausted = false

	if stamina != previous_stamina:
		stamina_changed.emit(stamina, max_stamina)
