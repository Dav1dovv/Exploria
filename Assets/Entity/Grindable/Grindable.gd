@icon("res://IconGodotNode/node_2D/icon_shovel.png")
extends Area2D
class_name Grindable

@export_range(1,100,1) var hp := 20
# drop

func take_damage(take:int):
	hp -= take
	if hp <= 0:
		queue_free()
