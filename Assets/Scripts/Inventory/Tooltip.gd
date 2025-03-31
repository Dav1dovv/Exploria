extends Control

@onready var name_: Label = $Panel/VBoxContainer/Name
@onready var label = $Panel/VBoxContainer/Description

func _ready():
	hide()  # Скрываем по умолчанию

# 🎯 Показываем описание
func show_tooltip(item_name : String,text: String, position: Vector2):
	name_.text = item_name
	label.text = text
	global_position = position
	show()

# ❌ Скрываем описание
func hide_tooltip():
	hide()
