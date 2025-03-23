extends Node2D

func _ready() -> void:
	$GenerateEnvironment.visible = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$GenerateEnvironment.visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$GenerateEnvironment.visible = false
