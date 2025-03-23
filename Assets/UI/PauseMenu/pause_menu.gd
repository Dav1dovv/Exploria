extends Control

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	visible = false
	
func pause():
	get_tree().paused = true
	visible = true
	$AnimationPlayer.play("blur")

func _input(event: InputEvent) -> void:
		if Input.is_key_pressed(KEY_ESCAPE) and !get_tree().paused:
			pause()
		elif Input.is_key_pressed(KEY_ESCAPE) and get_tree().paused:
			resume()

func _on_resume_pressed() -> void:
	resume()

func _on_exit_pressed() -> void:
	get_tree().quit()
