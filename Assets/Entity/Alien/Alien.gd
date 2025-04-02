extends BaseEntity
class_name Alien

var player
var motion : Vector2
@export var Level :int
@export var damage_strenght : int
@export var drop: Array[ItemResource]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	hp = max_hp
	
	
func _process(delta: float) -> void:
	
	if player != null : 
		$Skin/AnimationPlayer.play("Walk")
		position = position.move_toward(player.global_position, delta*speed * 10)
		if position.distance_to(player.global_position) > 100:
			$Skin/Body/Hands/AnimationPlayer.play("Attack")
			
		
		if global_position.x >= player.global_position.x:
			$Skin.scale.x = -1
		elif position.x < player.global_position.x:
			$Skin.scale.x = 1
	else: $Skin/AnimationPlayer.play("Idle")

	pass # Replace with function body.
func damage(knnockback,damage):
	var FLOAT_TEXT = preload("res://Assets/Scripts/FloatText/FloatText.tscn")
	var object = FLOAT_TEXT.instantiate()
	object.text =str(damage)
	object.position += Vector2(randf_range(-500,500),randf_range(-500,500))
	object.get_child(0).play("splash")
	call_deferred("add_child",object)
	take_damage(knnockback,damage,null)
	if hp<= 0:
		var drop_itm = randi_range(0, randi() % drop.size())
		var drop_cnt = randi() % 10
		Notification.show_notification(drop[drop_itm].display_name + " +" + str(drop_cnt), 1.0,drop[drop_itm].icon)
		if drop_itm == 0:drop[drop_itm].count += drop_cnt
		else: get_tree().get_first_node_in_group("Inventory").add_item(drop[drop_itm],drop_cnt)
		queue_free()
