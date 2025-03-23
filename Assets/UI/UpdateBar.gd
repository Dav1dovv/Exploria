@icon("res://IconGodotNode/color/icon_life_bar.png")
extends TextureProgressBar
class_name Progess_bar

func init_bar(count):
	max_value = count
	$Label.text = str(count)
func update_bar(count):
	value = count
	$Label.text = str(count)
