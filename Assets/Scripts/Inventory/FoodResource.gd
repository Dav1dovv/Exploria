@icon("res://IconGodotNode/node/icon_meat.png")
extends ItemResource
class_name FoodResource

@export var effects: Array[Effect]

func eat(player):
	for effect in effects:
		effect.apply_effect(player)
