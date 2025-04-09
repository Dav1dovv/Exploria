extends TextureRect
var COIN = preload("res://Assets/Scripts/Inventory/Items/Coin.tres")

func _ready() -> void:
	COIN.count = 50

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
		$Label.text = str(COIN.count)
