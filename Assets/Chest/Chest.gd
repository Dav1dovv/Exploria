@icon("res://IconGodotNode/node_2D/icon_chest.png")
extends Node2D

@export var drop_weapons : Array[WeaponResource]
@onready var interaction = $InteractionArea
@onready var particles: GPUParticles2D = $GPUParticles2D
var is_opened = false

func _ready():
	randomize()
	interaction.interact = Callable(self, "open")
	interaction.toDo = "open"

func open():
	if !is_opened:
		particles.restart()
		particles.emitting
		var rand_drop = randi_range(0,drop_weapons.size()-1)
		get_tree().get_first_node_in_group("NotificationManager").show_notification("you finded " + drop_weapons[rand_drop].display_name, 2.0, drop_weapons[rand_drop].icon)
		get_tree().get_first_node_in_group("Inventory").add_item(drop_weapons[rand_drop],1)
		$Sprite2D.frame = 1
		is_opened = true
