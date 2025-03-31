extends TextureRect  # Это просто область удаления

func _can_drop_data(_position, data):
	return data is InventorySlot  # Можно перетаскивать только слоты

func _drop_data(_position, data):
	if data is InventorySlot:
		data.set_item(null)  # Удаляем предмет
