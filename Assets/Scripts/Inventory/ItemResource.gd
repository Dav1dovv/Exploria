extends Resource
class_name RSC

@export var resource: String
@export_multiline var description: String
@export var max_count: int
@export var icon: Texture2D
@export var stackable: bool = true  # Можно ли стакать предметы

var count: int = 1

func _add(cnt):
	count += cnt
	
func use():
	pass
	
func can_use() -> bool:
	return true
	
func get_tooltip() -> String:
	return description
