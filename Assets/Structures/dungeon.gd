extends Node2D

@onready var interaction: Area2D = $InteractionArea

func _ready() -> void:
	$Sprite2D.frame = randi_range(0,9)
	interaction.interact = Callable(self, "open")
	interaction.toDo = "open"

func open():
	pass
