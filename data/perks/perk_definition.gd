class_name PerkDefinition
extends Resource

enum Effect {
	HEALTH,
	RELOAD_SPEED,
	MOVEMENT_SPEED,
	REGENERATION,
}

@export var perk_id := ""
@export var perk_name := "Avantage"
@export_range(0, 100000, 1) var price_credits := 1000
@export var effect: Effect = Effect.HEALTH
@export_range(0.1, 3.0, 0.01) var effect_multiplier := 1.0
