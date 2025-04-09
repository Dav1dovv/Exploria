@icon("res://IconGodotNode/node_2D/icon_shovel.png")
extends Grindable

@onready var particlces: GPUParticles2D = $GPUParticles2D


@export var drop : ItemResource
@export var random_sprite : bool = true

func _ready() -> void:
	particlces.texture = drop.icon
	$Sprite2D.visible = false
	$Shadow.visible = false
	
	randomize()
	if random_sprite:
		# Создаем взвешенный случайный выбор кадра
		var frame_weights = [1.0, 1.0, 0.01, 0.1, 1.0, 1.0,1.0]  # Веса для кадров (0 и 1 соответственно)
		if $Sprite2D.hframes > 7:
			# Добавляем равные веса для остальных кадров, если они есть
			for i in range(2, $Sprite2D.hframes):
				frame_weights.append(1.0)
		
		# Нормализуем веса
		var total_weight = 0.0
		for w in frame_weights:
			total_weight += w
		
		var random_value = randf() * total_weight
		var cumulative_weight = 0.0
		var selected_frame = 0
		
		for i in range(frame_weights.size()):
			cumulative_weight += frame_weights[i]
			if random_value <= cumulative_weight:
				selected_frame = i
				break
		
		$Sprite2D.frame = selected_frame
func VFX():
	$AnimationPlayer.play("Grind")


func grind(damage) -> void:
	if drop != null:
		particlces.restart()
		particlces.emitting = true
		
		Notification.show_notification(drop.display_name + " +1", 1.0,drop.icon)
		var inv = get_tree().get_first_node_in_group("Inventory")
		inv.add_item(drop,1)
		
		if $Sprite2D.frame == 2:
			var life_fruit = preload("res://Assets/Scripts/Inventory/Items/Life Fruit.tres")
			inv.add_item(life_fruit,1)
			Notification.show_notification(life_fruit.display_name + " +1", 1.0,life_fruit.icon)
		elif $Sprite2D.frame == 3:
			var Apple = preload("res://Assets/Scripts/Inventory/Items/Apple.tres")
			inv.add_item(Apple,1)
			Notification.show_notification(Apple.display_name + " +1", 1.0,Apple.icon)
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
	$Shadow.visible = true
	pass # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	$Sprite2D.visible = false
	$Shadow.visible = false
	pass # Replace with function body.
