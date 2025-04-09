extends BaseEntity
class_name Meduza

var player
var motion : Vector2
@export var Level :int
@export var damage_strenght : int
var COIN = preload("res://Assets/Scripts/Inventory/Items/Coin.tres")

const  DEATH = preload("res://Assets/Entity/Enemies/Audio/Enemy Death.wav")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = max_hp
	player = get_tree().get_first_node_in_group("Player")
	print("meduza created" + player.name)
	
	
	
func _process(delta: float) -> void:
	
	if player != null : 
		$AnimationPlayer.play("Walk")
		position = position.move_toward(player.global_position, delta*speed * 10)
	else: $AnimationPlayer.play("Idle")

	pass # Replace with function body.
@warning_ignore("shadowed_variable")
func damage(knnockback,damage):
	#$AudioStreamPlayer2D.pitch_scale = randf_range(-0.3,0.3)
	$AudioStreamPlayer2D.play()
	var FLOAT_TEXT = preload("res://Assets/Scripts/FloatText/FloatText.tscn")
	var object = FLOAT_TEXT.instantiate()
	object.text =str(damage)
	object.position += Vector2(randf_range(-500,500),randf_range(-500,500))
	object.get_child(0).play("splash")
	call_deferred("add_child",object)
	take_damage(knnockback,damage,null)
	if hp<= 0:
		$AudioStreamPlayer2D.stream = DEATH
		$AudioStreamPlayer2D.play()
		var drop = randi_range(1,10)
		Notification.show_notification(COIN.display_name + " +" + str(drop), 1.0,COIN.icon)
		COIN.count += 5
		await $AudioStreamPlayer2D.finished
		queue_free()
