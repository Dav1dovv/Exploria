extends Node
class_name attack_data

enum items_type{Melee,Distance,Food}

var curently_equiped : ItemResource = null
@export var strenght : int
@export var weapon_sprite :Sprite2D
@export var is_equiped : bool  = true
@onready var hit_zone: CollisionShape2D = %HitZone
@export var equiped_type : items_type

var is_wep = false


const CURS_SHOT = preload("res://Assets/Sprites/Cursors/tile_0055.png")
const CURS_WEP = preload("res://Assets/Sprites/Cursors/tile_0107.png")
const CURS_PICKAXE = preload("res://Assets/Sprites/Cursors/tile_0108.png")
const CURS_HAMMER = preload("res://Assets/Sprites/Cursors/tile_0110.png")
const CURS_BOMB = preload("res://Assets/Sprites/Cursors/tile_0127.png")
const CURS_INTERACT = preload("res://Assets/Sprites/Cursors/tile_0182.png")

func Equip_item(equip):
	print("equiped: ", equip.display_name)
	curently_equiped = equip
	weapon_sprite.texture = equip.icon
	if equip is WeaponResource:
		print("Agreed")
		hit_zone.scale.x = equip.hit_distance
		strenght = equip.damage_strength
		if equip.types == equip.WEPTypes.Pistol:
			print("GUN")
			Input.set_custom_mouse_cursor(CURS_SHOT,Input.CURSOR_ARROW,Vector2(8,8))
			weapon_sprite.offset = Vector2(4.5,-5.383)
			equiped_type = items_type.Distance
		elif equip.types == equip.WEPTypes.Melee:
			is_wep = true
			Input.set_custom_mouse_cursor(CURS_WEP,Input.CURSOR_ARROW,Vector2(0,0))
			weapon_sprite.offset = Vector2(-0.325,-5.593)
			equiped_type = items_type.Melee
		elif equip.types == equip.WEPTypes.Pickaxe:
			is_wep = false
			Input.set_custom_mouse_cursor(CURS_PICKAXE,Input.CURSOR_ARROW,Vector2(0,0))
			equiped_type = items_type.Melee
	pass
