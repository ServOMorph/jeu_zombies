class_name WallWeaponBuyDefinition
extends Resource

@export var buy_id := "achat_arme"
@export var weapon: Resource
@export_range(0, 100000, 1) var price_credits := 500
@export_range(0, 100000, 1) var ammo_price_credits := 150
