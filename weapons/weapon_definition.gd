class_name WeaponDefinition
extends Resource

@export var weapon_name := "Arme"
@export var damage := 20.0
@export var fire_interval_seconds := 0.25
@export var range_meters := 60.0
@export var spread_degrees := 1.5
@export var magazine_capacity := 12
@export var reserve_capacity := 48
@export var reload_duration_seconds := 1.2
@export var pellet_count := 1
@export var max_damage_per_shot := 0.0
@export_category("Modèle et son")
@export var visual_size := Vector3(0.45, 0.2, 0.7)
@export var visual_color := Color(0.55, 0.55, 0.58, 1.0)
@export var shot_tone_frequency := 180.0
@export var shot_tone_duration_seconds := 0.08
@export var shot_tone_amplitude := 0.16
