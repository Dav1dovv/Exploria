extends BaseEntity

var player
var motion : Vector2
@export var Level :int
@export var damage_strenght : int
var COIN = preload("res://Scripts/Inventory/Items/Coin.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	player = get_tree().get_first_node_in_group("Player")
	Level = randi_range(1,6)
	match  Level:
		1:
			$Slime.frame = 0
			$MoveTimer.wait_time = 2
			$MoveTimer.start()
		2:
			$Slime.frame = 1
			hp += 3
			$MoveTimer.wait_time = 1.5
			$MoveTimer.start()
		3:
			$Slime.frame = 2
			hp += 4
			$MoveTimer.wait_time = 2
			$MoveTimer.start()
		4:
			$Slime.frame = 3
			hp += 5
			$MoveTimer.wait_time = 2.5
			$MoveTimer.start()
		5:
			$Slime.frame = 4
			hp += 6
			$MoveTimer.wait_time = 2
			$MoveTimer.start()
	$Slime.frame = Level
	
func _process(delta: float) -> void:
	$AnimationPlayer.play("Walk")
	if player != null : 
		position = position.move_toward(player.global_position, delta*speed * 10)

	pass # Replace with function body.
func damage(knnockback,damage):
	var FLOAT_TEXT = preload("res://Scripts/FloatText/FloatText.tscn")
	var object = FLOAT_TEXT.instantiate()
	object.text =str(damage)
	object.position += Vector2(randf_range(-500,500),randf_range(-500,500))
	object.get_child(0).play("splash")
	call_deferred("add_child",object)
	take_damage(knnockback,damage,null)
	if hp<= 0:
		var drop = randi_range(1,10)
		get_tree().get_first_node_in_group("NotificationManager").show_notification(COIN.resource + " +" + str(drop), 1.0,COIN.icon)
		COIN.count += 5
		queue_free()
