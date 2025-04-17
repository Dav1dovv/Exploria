extends TextureRect
class_name TrashSlot

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return "item" in data and is_instance_of(data.item, ItemResource)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var inventory = get_parent().get_parent().get_parent()  # Adjust path to Inventory node
	if inventory and inventory.has_method("remove_item"):
		inventory.remove_item(data.item, data.ammount)
		data.item = null
		data.ammount = 0
		data.update_ui()
