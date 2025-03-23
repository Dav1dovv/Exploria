extends Sprite2D

@export var rotation_speed : float = 2
func _process(delta: float) -> void:
	rotate(rotation_speed * delta)
