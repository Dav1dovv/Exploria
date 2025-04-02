@icon("res://IconGodotNode/color/icon_weapon.png")
extends RSC
class_name Weapon

@export var damage_strength: int = 10
@export var hit_effect: Array[Effect] = []
@export var is_weapon: bool = true
@export var hit_distance: float = 1.5

func _init():
	max_count = 1  # Оружия обычно не стакаются

func equip():
	#print("⚔ Удар ", display_name, "! Наносит ", damage_strength, " урона.")
	pass
