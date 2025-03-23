extends Node
class_name attack_data

@export var strenght : int
@export var weapom_texture : Texture2D
@export var weapon_sprite :Sprite2D

func update_wep(equip :Weapon):
	print(equip.resource + "экипировано")
	strenght = equip.damage_strength
	weapom_texture = equip.icon
	weapon_sprite.texture = weapom_texture
	pass
