@icon("res://IconGodotNode/node_2D/icon_shovel.png")
extends Grindable

@onready var particlces: GPUParticles2D = $GPUParticles2D


@export var drop : RSC
@export var variations : int
@export var random_sprite : bool = true

func _ready() -> void:
	particlces.texture = drop.icon
	$Sprite2D.visible = false
	randomize()
	if random_sprite:$Sprite2D.frame = randi_range(0,variations)
func VFX():
	$AnimationPlayer.play("Grind")


func grind(damage) -> void:
	if drop != null:
		particlces.restart()
		particlces.emitting
		get_tree().get_first_node_in_group("NotificationManager").show_notification(drop.resource + " +1", 1.0,drop.icon)
		var inv = get_tree().get_first_node_in_group("Inventory")
		inv.add_item(drop,1)
		var FLOAT_TEXT = preload("res://Assets/Scripts/FloatText/FloatText.tscn")
		var object = FLOAT_TEXT.instantiate()
		object.position += Vector2(randf_range(-100,100),randf_range(-100,100))
		object.text = str(damage)
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
