@icon("res://IconGodotNode/node_2D/icon_shovel.png")
extends Area2D
class_name Grindable

@export_range(1,100,1) var hp := 20
# drop

func take_damage(take:int):
	hp -= take
	if hp <= 0:
		queue_free()

func S_VFX(object):
	var tween = create_tween()
	@warning_ignore("redundant_await")
	tween.tween_property(object, "rotation", randf_range(-0.2,0.2),0.1)
	await tween.tween_property(object, "scale",Vector2(0.4,0.4) ,0.1)
	tween.tween_property(object, "scale", Vector2(0.5,0.5) ,0.1)
	@warning_ignore("redundant_await")
	tween.tween_property(object, "rotation", 0,0)
	tween.tween_property(object, "scale", Vector2(1,1) ,0.1)
