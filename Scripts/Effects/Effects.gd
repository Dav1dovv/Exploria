@icon("res://IconGodotNode/node/icon_tree.png")
extends Resource
class_name Effect

@export var effect_icon :Texture2D
@export var effect_value: int = 10  # Сила эффекта
@export var duration: float = 0.0  # Длительность эффекта (если нужно)
