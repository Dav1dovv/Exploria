@icon("res://Engine/Icons/32x32/interact.png")
extends Area2D

const base = "[E] to "

@export var toDo := "interact"
@onready var label: Label = $Label

var is_in_zone = false

var interact:Callable = func():
	pass

func _ready():
	label.visible = false

@warning_ignore("unused_parameter")
func _on_body_entered(body: Node2D):
	is_in_zone = true
	label.text = base + toDo
	label.visible = true
	pass # Replace with function body.


@warning_ignore("unused_parameter")
func _on_body_exited(body: Node2D):
	is_in_zone = false
	label.visible = false
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if is_in_zone:
		if event.is_action_pressed("Interact"):
			label.visible = false
			interact.call()
