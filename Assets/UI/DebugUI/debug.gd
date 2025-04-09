extends Control

@onready var label: Label = $Label

func _process(delta: float) -> void:
	label.text = "FPS: " + str(Engine.get_frames_per_second()) + "/60.0
	TimeScale: " + str(Engine.time_scale) + "
	Time Delta: " + str(delta) 
	
	
@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_F3):
		visible = !visible
