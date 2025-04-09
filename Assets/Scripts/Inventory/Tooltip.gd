extends Control

@onready var name_: Label = $Panel/VBoxContainer/Name
@onready var label = $Panel/VBoxContainer/Description

func _ready():
	hide()  # Скрываем по умолчанию

func show_tooltip(item_name: String, text: String):
	name_.text = item_name  # Здесь передавайте item.display_name
	label.text = text
# ❌ Скрываем описание
func hide_tooltip():
	hide()
