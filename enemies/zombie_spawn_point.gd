class_name ZombieSpawnPoint
extends Marker3D

@export var zone_id := "accueil"
@export var is_enabled := true


func _ready() -> void:
	add_to_group("zombie_spawn_points")
