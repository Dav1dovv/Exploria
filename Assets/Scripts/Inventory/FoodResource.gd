@icon("res://IconGodotNode/node/icon_meat.png")
extends RSC
class_name Food

@export var effects: Array[Effect]

func eat(player):
	for i in effects.size():
		effects[i].apply_effect(player)
