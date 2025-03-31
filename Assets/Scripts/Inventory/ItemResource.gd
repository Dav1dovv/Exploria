extends Resource
class_name RSC

@export var resource: String
@export_multiline var description: String
@export var max_count: int
@export var icon: Texture2D

var count: int = 1
@export var item_path : String = ""
func _add(cnt):
	count += cnt
