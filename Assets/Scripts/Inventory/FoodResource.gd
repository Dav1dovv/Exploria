@icon("res://IconGodotNode/node/icon_meat.png")
extends RSC
class_name Food

@export var effects: Array[Effect]

func eat(player):
	for effect in effects:
		effects[effect].apply_effect(player)
		print("✅ Применён эффект:", effect.effect_type, "на", effect.value)
