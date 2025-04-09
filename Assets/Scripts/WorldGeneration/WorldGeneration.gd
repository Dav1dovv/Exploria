@icon("res://IconGodotNode/node_2D/icon_dice.png")
@tool
extends Node2D
class_name GenerateEnvironment

@export var objects_to_spawn : Array[GenerationObject]  # Список ресурсов с настройками объектов
@export var object_spawn_chance : float = 0.7  # Общая вероятность появления объекта в ячейке

@export_group("Spawn Zone Settings")
@export var spawn_area_size : Vector2 = Vector2(10, 10)
@export var grid_size : Vector2 = Vector2(1, 1)  # Размер сетки для генерации
@export var spawn_zone_center : Vector2 = Vector2(0, 0)  # Центр зоны спавна

var occupied_cells : Dictionary = {}
@export_tool_button("Generate","Callable")
var regenerate = func(): regenerate_world()


func is_cell_occupied(cell_position: Vector2) -> bool:
	var cell_key = cell_position.snapped(grid_size)
	return occupied_cells.has(cell_key)

func mark_cell_as_occupied(cell_position: Vector2) -> void:
	var cell_key = cell_position.snapped(grid_size)
	occupied_cells[cell_key] = true

func spawn_objects():
	clear_existing_objects()
	var grid_width = int(spawn_area_size.x / grid_size.x)
	var grid_height = int(spawn_area_size.y / grid_size.y)
	
	for x in range(grid_width):
		for y in range(grid_height):
			var cell_position = Vector2(x * grid_size.x, y * grid_size.y) - spawn_area_size / 2 + grid_size / 2 + spawn_zone_center
			
			if randf() > object_spawn_chance or is_cell_occupied(cell_position):
				continue
			else:
				spawn_object(cell_position)

func spawn_object(cell_position: Vector2):
	var shuffled_objects = objects_to_spawn.duplicate()
	shuffled_objects.shuffle()

	for obj_data in shuffled_objects:
		if randf() < obj_data.spawn_probability:
			var new_spawn = obj_data.object_scene.instantiate()
			new_spawn.position = cell_position
			add_child(new_spawn)
			mark_cell_as_occupied(cell_position)
			break

func clear_existing_objects():
	for child in get_children():
		child.queue_free()

func regenerate_world():
	clear_existing_objects()
	spawn_objects()
