@icon("res://IconGodotNode/node_2D/icon_skull.png")
extends Node2D

@export var player : CharacterBody2D
@export_range(150,350) var spawn_distance : float
@export var day_enemies: Array[PackedScene]  # Враги, которые появляются ночью
@export var night_enemies: Array[PackedScene]  # Враги, которые появляются днём
@export var max_enemies: int = 700  # Максимальное количество врагов
@export var day_start_hour: int = 6  # Час начала дня (6:00)
@export var night_start_hour: int = 18  # Час начала ночи (18:00)
@onready var time_cycle: CanvasModulate = %DayNight

var current_enemy_pool: Array[PackedScene]
var can_spawn: bool = true
var minute: int = 0
var hour: int = 0
var day: int = 0
var second: int = 0

func _ready() -> void:
	randomize()
	# Подключаемся к сигналу времени из daynightcycle
	if time_cycle:
		time_cycle.time_tick.connect(_on_time_tick)
	update_enemy_pool()

func _on_time_tick(new_day: int, new_hour: int, new_minute: int) -> void:
	self.day = new_day
	self.hour = new_hour
	self.minute = new_minute
	update_enemy_pool()

func update_enemy_pool() -> void:
	# Определяем, день сейчас или ночь, и выбираем соответствующий пул врагов
	if hour >= day_start_hour and hour < night_start_hour:
		current_enemy_pool = night_enemies
	else:
		current_enemy_pool = day_enemies

func _physics_process(_delta):
	if get_tree().get_nodes_in_group("Enemy").size() < max_enemies:
		can_spawn = true
	else:
		can_spawn = false

func spawn(pos: Vector2, elite: bool = false):
	if not can_spawn and not elite:
		return
	
	if current_enemy_pool.size() == 0:
		return
	
	var variation = randi_range(0, current_enemy_pool.size() - 1)
	var enemy_instance = current_enemy_pool[variation].instantiate()
	enemy_instance.position = pos
	get_tree().current_scene.add_child(enemy_instance)

func get_random_position() -> Vector2:
	return player.position + spawn_distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

func amount(number: int = 1):
	for i in range(number):
		spawn(get_random_position())

func _on_mob_spawner_timer_timeout() -> void:
	second += 1
	randomize()
	amount(randi_range(1, randi() % 10))
	$MobSpawnerTimer.wait_time = randf_range(10, 30)
