extends Node
class_name attack_data

@export var strenght : int
@export var weapom_texture : Texture2D
@export var weapon_sprite :Sprite2D
@export var is_wep : bool = false
@export var is_equiped : bool  = true
@onready var hit_zone: CollisionShape2D = %HitZone


func update_wep(equip :Weapon):
	
	print(equip.resource + "экипировано")
	strenght = equip.damage_strength
	weapom_texture = equip.icon
	weapon_sprite.texture = weapom_texture
	is_wep = equip.is_weapon
	hit_zone.scale.x = equip.hit_distance
	pass
