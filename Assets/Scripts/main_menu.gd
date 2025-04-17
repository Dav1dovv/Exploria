extends Control
var start = false

func  _ready() -> void:
	$"Start Button/AnimationPlayer".play("idle")
func _input(event: InputEvent) -> void:
	if Input.is_anything_pressed() and !start:
		$"Start Button".queue_free()
		$"GameButtons Panel/AnimationPlayer".play("TurnON")
		start = true
		

func _on_start_pressed() -> void:
	Scene.load_scene("res://Assets/Locations/Planets/Oktavia.tscn",true)
	pass # Replace with function body.


func _on_options_pressed() -> void:
	$"GameButtons Panel/VBoxContainer/Options".visible = !$"GameButtons Panel/VBoxContainer/Options".visilbe
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
