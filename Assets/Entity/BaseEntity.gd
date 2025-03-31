@icon("res://IconGodotNode/node/icon_character.png")
extends CharacterBody2D
class_name BaseEntity


@export_category("Entity Settings")
var multipiler := 100
@export_range(0,10,1) var speed := 2



@export_category("Stats")
@export_range(1,100,1) var LVL := 1
@export_range(1,100,1) var max_hp := 20
var hp : int
@export_range(1,100,1) var max_exp := 20
var exp : int
@export_range(1,20,1) var defence := 1


@export_group("KnockBack")
@export var receive_knockback := true
@export var knockback_modifier:= 5
@onready var particles: GPUParticles2D = $GPUParticles2D

func take_damage(enemyVelocity: Vector2, received_damage: int,attack_effect :Effect):
	particles.restart()
	particles.emitting
	print(hp)
	_receive_knockback(enemyVelocity)
	print("damaged " + str(received_damage))
	hp -= received_damage
	print(hp)
	if attack_effect == null:
		print("no attack effect")


func _receive_knockback(damage_pos: Vector2):
	if receive_knockback:
		var knockback_direction = damage_pos.direction_to(self.global_position)
		var knockback_strenght = 1.5 * knockback_modifier
		var knockback = knockback_direction * knockback_strenght
		
		global_position += knockback

	#_damage_effect()

##effects
func Heal(value):
	hp += value

func Take_life(value):
	max_hp = max_hp + 10
	hp += value
	var delay = Timer.new()
	await delay.timeout
	max_hp = max_hp - 10
