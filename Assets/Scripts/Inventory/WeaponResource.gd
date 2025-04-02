@icon("res://IconGodotNode/color/icon_weapon.png")
extends ItemResource
class_name WeaponResource

@export var damage_strength: int = 10
@export var hit_effect: Array[Effect]
@export var hit_distance: float = 1.5
@export var is_wep : bool  = true

func equip():
	print("⚔ Экипировано оружие: ", display_name)
