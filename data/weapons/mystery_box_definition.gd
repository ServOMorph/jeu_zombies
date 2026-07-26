class_name MysteryBoxDefinition
extends Resource

@export var box_id := "caisse_aleatoire"
@export_range(0, 100000, 1) var price_credits := 1500
@export var possible_weapons: Array[Resource] = []
