extends Resource
class_name RSC

@export var resource: String
@export_multiline var description: String
@export var max_count: int
@export var icon: Texture2D

var count: int = 1

func _add(cnt):
	count += cnt
