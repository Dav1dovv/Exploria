extends Node2D


@onready var player: Player = %Player

@export var map_size: Vector2
@export_group("Biomes")
@export var Desert :Array[GenerationObject]
@export var DeathDesert :Array[GenerationObject]
@export var DarkLands :Array[GenerationObject]
@export var Simple : Array[GenerationObject]


var biomes = [Desert,DeathDesert,DarkLands, Simple]

func _ready() -> void:
	var rand_biom = randi() % biomes.size()
	var randX = randf_range(-map_size.x,map_size.x)
	var randY = randf_range(-map_size.y,map_size.y)
	
	player.position = Vector2(randX,randY)
	
	match rand_biom:
		0:
			$GenerateEnvironment.objects_to_spawn = Desert
			$GenerateEnvironment.object_spawn_chance = 0.1
		1:
			$GenerateEnvironment.objects_to_spawn = DeathDesert
			$TileMapLayer.self_modulate = Color.ANTIQUE_WHITE
			$GenerateEnvironment.object_spawn_chance = 0.04
		
		2:
			$GenerateEnvironment.objects_to_spawn = DarkLands
			$TileMapLayer.self_modulate = Color.BLUE_VIOLET
			$GenerateEnvironment.object_spawn_chance = 0.05
		
		3:
			$GenerateEnvironment.objects_to_spawn = Simple
			$GenerateEnvironment.object_spawn_chance = 0.2
		
	


	$GenerateEnvironment.regenerate_world()
