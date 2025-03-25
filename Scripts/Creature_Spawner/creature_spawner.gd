@icon("res://IconGodotNode/node_2D/icon_skull.png")
extends Node2D

@export var player : CharacterBody2D
@export var enemy: Array[PackedScene]

func _ready() -> void:
	print("monster spawner size: " + str(enemy.size()))

var distance = 200
var can_spawn : bool = true
var minute : int:
	set(value):
		minute = value

 
var second : int:
	set(value):
		second = value
		if second >= 10:
			second -= 10
			minute += 1

		
func _physics_process(_delta):
	if get_tree().get_node_count_in_group("Enemy") < 700:
		can_spawn = true
	else:
		can_spawn = false
 
func spawn(pos : Vector2, elite : bool = false):
	if not can_spawn and not elite:
		return
	
	var variation = randi_range(0,enemy.size()-1)
	var enemy_instance = enemy[variation].instantiate()
	#enemy_instance.position = get_random_position()
	enemy_instance.position = pos
	#enemy_instance.player_reference = player
	#enemy_instance.elite = elite
	get_tree().current_scene.add_child(enemy_instance)
 
func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
 
 
func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position())


func _on_mob_spawner_timer_timeout() -> void:
	second += 1
	amount(randi_range(1,5))
	$MobSpawnerTimer.wait_time = randf_range(8,15)
 
	pass # Replace with function body.
func _on_pattern_timeout():
	for i in range(75):
		spawn(get_random_position())
 
 
func _on_elite_timeout():
	spawn(get_random_position(), true)
