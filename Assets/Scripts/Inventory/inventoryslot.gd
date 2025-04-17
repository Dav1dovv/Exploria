extends TextureButton
class_name InventorySlot

@export var item: ItemResource = null:
	set(value):
		item = value
		if value == null:
			$Icon.texture = null
			$Count.text = ""
		else:
			$Icon.texture = value.icon
			$Count.text = str(ammount) if ammount > 1 else ""

@export var ammount: int = 0:
	set(value):
		ammount = value
		$Count.text = str(value) if value > 1 else ""
		if ammount <= 0:
			item = null

func set_ammount(value: int) -> void:
	ammount = value

func add_ammount(value: int) -> void:
	ammount += value

func sub_ammount(value: int) -> void:
	ammount -= value

func update_ui() -> void:
	if item == null:
		$Icon.texture = null
		$Count.text = ""
	else:
		$Icon.texture = item.icon
		$Count.text = str(ammount) if ammount > 1 else ""

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is InventorySlot and is_instance_of(data.item, ItemResource)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if not data is InventorySlot:
		return

	# Swap items and amounts
	var temp_item = item
	var temp_amount = ammount
	item = data.item
	ammount = data.ammount
	data.item = temp_item
	data.ammount = temp_amount

	# Update UI for both slots
	update_ui()
	data.update_ui()

	# Notify parent inventory or hotbar to update
	if get_parent().has_method("update"):
		get_parent().update()
	if data.get_parent().has_method("update"):
		data.get_parent().update()

	# Trigger inventory_changed signal if part of inventory
	var inventory = get_inventory()
	if inventory:
		inventory.emit_signal("inventory_changed")

func _get_drag_data(at_position: Vector2) -> Variant:
	if item:
		var preview_texture = TextureRect.new()
		preview_texture.texture = item.icon
		preview_texture.size = Vector2(18, 18)
		preview_texture.position = -Vector2(8, 8)

		var preview_control = Control.new()
		preview_control.add_child(preview_texture)
		set_drag_preview(preview_control)
		return self
	return null

func get_inventory() -> Inventory:
	var parent = get_parent()
	while parent and not parent is Inventory:
		parent = parent.get_parent()
	return parent if parent is Inventory else null
