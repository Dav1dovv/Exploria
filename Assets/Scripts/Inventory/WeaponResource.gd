@icon("res://IconGodotNode/color/icon_weapon.png")
extends ItemResource
class_name WeaponResource

enum WEPTypes {Melee,Pistol,Magic,Pickaxe}

@export var types: WEPTypes 
@export var damage_strength: int = 10
@export var hit_effect: Array[Effect]
@export var hit_distance: float = 1.5
@export var projectile: PackedScene

func equip():
	print(" Экипировано : ", display_name)
