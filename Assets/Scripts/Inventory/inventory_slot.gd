extends TextureButton
class_name InventorySlot

signal slot_updated(slot)

var item: ItemResource = null
@onready var icon: TextureRect = $TextureRect
@onready var count_label: Label = $Label
@onready var tooltip: Control = $Tooltip

func set_item(new_item: ItemResource):
	item = new_item
	update_slot()
	emit_signal("slot_updated", self)

func update_slot():
	if not is_instance_valid(icon) or not is_instance_valid(count_label):
		return
	
	if item:
		icon.texture = item.icon
		count_label.text = str(item.count) if item.stackable and item.count > 1 else ""
		icon.visible = true
		count_label.visible = item.stackable
	else:
		icon.texture = null
		count_label.text = ""
		icon.visible = false
		count_label.visible = false

func clear_slot():
	set_item(null)

func has_item() -> bool:
	return item != null

func _get_drag_data(_position):
	if not item:
		return null
		
	var drag_preview = TextureRect.new()
	drag_preview.texture = item.icon
	drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	drag_preview.custom_minimum_size = Vector2(32, 32)
	set_drag_preview(drag_preview)
	return self

func _can_drop_data(_position, data):
	if not (data is InventorySlot):
		return false
	if not data.item:
		return true
		
	# Проверяем возможность стака
	if item and data.item.resource_path == item.resource_path and item.stackable:
		return item.count < item.max_count
	return not item or item.stackable

func _drop_data(_position, data):
	if not (data is InventorySlot):
		return
	
	# Стакаем предметы
	if item and data.item and item.resource_path == data.item.resource_path and item.stackable:
		var total = item.count + data.item.count
		if total <= item.max_count:
			item.count = total
			data.clear_slot()
		else:
			item.count = item.max_count
			data.item.count = total - item.max_count
	else:
		# Меняем местами
		var temp = item
		set_item(data.item)
		data.set_item(temp)
	
	update_slot()
	data.update_slot()

func _on_mouse_entered():
	if item and is_instance_valid(tooltip):
		tooltip.show_tooltip(
			item.display_name,
			item.description,
			get_global_mouse_position() + Vector2(16, 16)
		)

func _on_mouse_exited():
	if is_instance_valid(tooltip):
		tooltip.hide_tooltip()
