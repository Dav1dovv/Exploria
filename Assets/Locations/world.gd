@icon("res://IconGodotNode/color/icon_map_2.png")
extends Node2D

@export var location_chunks: Array[PackedScene]
@export var map_size: int = 5  
@export var chunk_size: Vector2 = Vector2(512, 512)  

var used_positions = []
var save_path = "user://map_save.json"

func _ready():
	load_map()
	if used_positions.is_empty():
		generate_map()
	pass

func generate_map():
	used_positions.clear()
	
	for x in range(map_size):
		for y in range(map_size):
			var pos = Vector2(x, y)
			if pos == Vector2(0, 0):
				continue
			if pos in used_positions:
				continue
			
			add_chunk(pos)
	save_map()

func generate_new_islands():
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	
	for dir in directions:
		var new_pos = used_positions[-1] + dir  
		if new_pos in used_positions:
			continue  
		
		add_chunk(new_pos)
	save_map()

func add_chunk(pos: Vector2):
	var chunk_scene = location_chunks.pick_random()
	var chunk_instance = chunk_scene.instantiate()
	chunk_instance.position = pos * chunk_size  
	add_child(chunk_instance)
	used_positions.append(pos)

func save_map():
	var data = {
		"used_positions": used_positions.map(func(pos): return [pos.x, pos.y])
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_map():
	if not FileAccess.file_exists(save_path):
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if data and "used_positions" in data:
		used_positions.clear()
		for pos in data["used_positions"]:
			add_chunk(Vector2(pos[0], pos[1]))
