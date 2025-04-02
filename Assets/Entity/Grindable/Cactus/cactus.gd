@icon("res://IconGodotNode/node_2D/icon_shovel.png")
extends Grindable

@export var drop : ItemResource
@export var variations : int
func _ready() -> void:
	$Sprite2D.visible = false
	randomize()
	$Sprite2D.frame = randi_range(0,variations)
func VFX():
	$AnimationPlayer.play("Grind")


func grind(damage) -> void:
	if drop != null:
		Notification.show_notification(drop.display_name + " +1", 1.0,drop.icon)
		var inv = get_tree().get_first_node_in_group("Inventory")
		inv.add_item(drop,1)
		var FLOAT_TEXT = preload("res://Assets/Scripts/FloatText/FloatText.tscn")
		var object = FLOAT_TEXT.instantiate()
		object.position += Vector2(randf_range(-500,500),randf_range(-500,500))
		object.get_child(0).play("splash")
		call_deferred("add_child",object)
	take_damage(damage)
	VFX()
	pass # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	$Sprite2D.visible = true
	pass # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	$Sprite2D.visible = false
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(global_position,3,null)
	#body.update_health()
