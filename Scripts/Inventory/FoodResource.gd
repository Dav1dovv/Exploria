@icon("res://IconGodotNode/node/icon_meat.png")
extends RSC
class_name Food

@export var effects: Array[Effect]

# 🍎 Использование еды
func use():
	print("🍏 Съедено! Применяются эффекты: ", effects)
