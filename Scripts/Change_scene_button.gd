extends Button
class_name change_scene_button

@export var path_to_scene :String

func _pressed() -> void:
	Loading.load_scene(path_to_scene,true)
