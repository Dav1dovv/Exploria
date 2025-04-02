extends Node
class_name attack_data

@export var strenght : int
@export var weapom_texture : Texture2D
@export var weapon_sprite :Sprite2D
@export var is_wep : bool = false
@export var is_equiped : bool  = true
@onready var hit_zone: CollisionShape2D = %HitZone

const CURS_SHOT = preload("res://Assets/Sprites/Cursors/tile_0055.png")
const CURS_WEP = preload("res://Assets/Sprites/Cursors/tile_0107.png")
const CURS_PICKAXE = preload("res://Assets/Sprites/Cursors/tile_0108.png")
const CURS_HAMMER = preload("res://Assets/Sprites/Cursors/tile_0110.png")
const CURS_BOMB = preload("res://Assets/Sprites/Cursors/tile_0127.png")
const CURS_INTERACT = preload("res://Assets/Sprites/Cursors/tile_0182.png")
func update_wep(equip :WeaponResource):
	
	print(equip.display_name + "экипировано")
	strenght = equip.damage_strength
	weapom_texture = equip.icon
	weapon_sprite.texture = weapom_texture
	is_wep = equip.is_wep
	hit_zone.scale.x = equip.hit_distance
	if is_wep: Input.set_custom_mouse_cursor(CURS_WEP,Input.CURSOR_ARROW,Vector2(0,0))
	else:Input.set_custom_mouse_cursor(CURS_PICKAXE,Input.CURSOR_ARROW,Vector2(0,0))
	pass
