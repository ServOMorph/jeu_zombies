class_name ZombieDefinition
extends Resource

@export var display_name := "Zombie standard"
@export_range(1.0, 1000.0, 1.0) var max_health := 100.0
@export_range(0.1, 20.0, 0.1) var move_speed := 2.8
@export_range(1.0, 500.0, 1.0) var attack_damage := 15.0
@export_range(0.5, 5.0, 0.1) var attack_range_meters := 1.6
@export_range(0.1, 5.0, 0.05) var attack_cooldown_seconds := 1.0
@export_range(0.05, 3.0, 0.05) var path_refresh_seconds := 0.35
@export_range(0, 10000, 1) var credit_reward := 50
