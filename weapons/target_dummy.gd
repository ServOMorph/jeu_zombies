class_name TargetDummy
extends StaticBody3D

signal health_changed(current_health: float, maximum_health: float)

@export var max_health := 100.0
var health := 100.0


func _ready() -> void:
	reset()


func receive_damage(amount: float) -> bool:
	if amount <= 0.0 or health <= 0.0:
		return false
	health = maxf(0.0, health - amount)
	health_changed.emit(health, max_health)
	return true


func reset() -> void:
	health = max_health
	health_changed.emit(health, max_health)
