extends Area2D

@export var path_to_location :String

func _on_body_entered(body: Node2D) -> void:
	Loading.load_scene(path_to_location,true)
