@icon("res://IconGodotNode/node/icon_potion.png")
extends Effect
class_name heal_life

func apply_effect(player):
	Heal_life(player)

func Heal_life(player):
	player.Take_life(effect_value)
