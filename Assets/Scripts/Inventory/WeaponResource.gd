@icon("res://IconGodotNode/color/icon_weapon.png")
extends RSC
class_name Weapon  # Название с большой буквы (стандарт Godot)

@export var damage_strength: int
@export var hit_effect: Array[Effect]
@export var is_weapon := false
@export var hit_distance : float
# ⚔ Использование оружия
func equip():
	
	print("⚔ Удар оружием! Наносит ", damage_strength, " урона.")
