@icon("res://IconGodotNode/node/icon_potion.png")
extends Effect
class_name heal

func apply_effect(player):
	Heal(player)

func Heal(player):
	var delay = Timer.new()
	delay.wait_time = duration
	var tck = Timer.new()
	tck.wait_time = 1
	await tck.timeout
	player.Heal(effect_value)
