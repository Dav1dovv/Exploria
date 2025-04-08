extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file_acs = FileAccess
	var dir = DirAccess.open("user://")
	dir.make_dir("Saves")
	
	dir = DirAccess.open("user://Saves")
	
