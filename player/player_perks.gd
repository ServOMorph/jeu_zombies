class_name PlayerPerks
extends RefCounted

signal perk_purchased(perk_id: String)

var _owned: Dictionary = {}


func reset() -> void:
	_owned.clear()


func is_owned(perk_id: String) -> bool:
	return _owned.has(perk_id)


func try_purchase(definition: PerkDefinition) -> bool:
	if definition == null or is_owned(definition.perk_id):
		return false
	if not GameSession.try_purchase(definition.perk_name, definition.price_credits):
		return false
	_owned[definition.perk_id] = definition
	perk_purchased.emit(definition.perk_id)
	return true


func get_effect_multiplier(effect: PerkDefinition.Effect) -> float:
	var multiplier := 1.0
	for definition: PerkDefinition in _owned.values():
		if definition.effect == effect:
			multiplier *= definition.effect_multiplier
	return multiplier
