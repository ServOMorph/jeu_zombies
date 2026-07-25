class_name WaveDefinition
extends Resource

@export var display_name := "Vague"
@export var spawn_zone_id := "accueil"
@export_range(1, 256, 1) var zombie_count := 6
@export_range(0.1, 10.0, 0.1) var health_multiplier := 1.0
@export_range(0.1, 30.0, 0.1) var spawn_interval_seconds := 1.0
