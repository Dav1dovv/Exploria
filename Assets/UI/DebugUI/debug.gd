extends Control

@onready var label: Label = $Label

func _physics_process(delta: float) -> void:
	label.text = "FPS: " + str(Engine.get_frames_per_second()) + "/60.0
	TimeScale: " + str(Engine.time_scale) 
	
	
func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_F3):
		visible = !visible
