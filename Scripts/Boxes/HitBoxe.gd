@icon("res://IconGodotNode/node_2D/icon_hitbox.png")
extends Area2D
class_name HitBox

@export var attack_node:attack_data
@export var player : Node2D


func _on_area_entered(area: Area2D) -> void:
	if attack_node.strenght != 0:
		if area.is_in_group("Grind"):
			area.grind(attack_node.strenght)
	#		player.stamina -= 1
			player.stamina_update()
	if attack_node.strenght != 0:
		if area.is_in_group("Entity"):
			area.get_parent().damage(global_position,attack_node.strenght)
			player.stamina -= 1
			player.stamina_update()

func _on_body_entered(body: Node2D) -> void:
	if attack_node.strenght != 0:
		if body.is_in_group("Entity"):
			body.get_parent().damage(global_position,attack_node.strenght)
			player.stamina -= 1
			player.stamina_update()
