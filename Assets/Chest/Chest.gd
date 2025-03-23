@icon("res://IconGodotNode/node_2D/icon_chest.png")
extends Node2D

@onready var interaction = $InteractionArea
var is_opened = false

func _ready():
	randomize()
	interaction.interact = Callable(self, "open")
	interaction.toDo = "open"

func open():
	if !is_opened:
		get_tree().get_first_node_in_group("World").generate_new_islands()
		get_tree().get_first_node_in_group("NotificationManager").show_notification("Unlocked new Island", 2.0, null)
		
		print("open")
		$Sprite2D.frame = 1
		is_opened = true
