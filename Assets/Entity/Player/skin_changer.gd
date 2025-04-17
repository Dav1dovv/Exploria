extends Node

@export var skin_parts : Array[Sprite2D]
@export var skin : Texture2D

func _ready() -> void:
	for i in skin_parts.size():
		skin_parts[i].texture = skin
