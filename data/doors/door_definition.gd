class_name DoorDefinition
extends Resource

@export var door_id := "porte"
@export var display_name := "Porte"
@export_range(0, 100000, 1) var price_credits := 100
@export var connected_zones := PackedStringArray()
@export var starts_open := false
