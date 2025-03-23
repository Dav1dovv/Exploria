extends TextureRect
var COIN = preload("res://Scripts/Inventory/Items/Coin.tres")

func _ready() -> void:
	COIN.count = 50

func _process(delta: float) -> void:
		$Label.text = str(COIN.count)
