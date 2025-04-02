extends Control
var start = false

func  _ready() -> void:
	$Label/AnimationPlayer.play("idle")
func _input(event: InputEvent) -> void:
	if Input.is_anything_pressed() and !start:
		$Label.queue_free()
		$Panel/AnimationPlayer.play("TurnON")
		start = true
		


func _on_button_pressed() -> void:
	Scene.load_scene("res://Assets/Locations/Planets/Oktavia.tscn",true)
	pass # Replace with function body.
