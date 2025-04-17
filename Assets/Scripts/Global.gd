extends Node

func _ready() -> void:
	#var file_acs = FileAccess # this variable never used
	var dir = DirAccess.open("user://")
	dir.make_dir("Saves")
	
	dir = DirAccess.open("user://Saves")
	
