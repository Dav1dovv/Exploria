extends TextureButton

class_name InventorySlot

var item: RSC = null
@onready var icon = $TextureRect
@onready var count_label = $Label

func set_item(new_item: RSC):
	item = new_item
	if item and icon:
		icon.texture = item.icon
		count_label.text = str(item.count) if item.count > 1 else ""
		icon.visible = true
		count_label.visible = true
	else:
		if icon:
			icon.texture = null
		if count_label:
			count_label.text = ""
		if icon:
			icon.visible = false
		if count_label:
			count_label.visible = false

# 🖱️ Начало перетаскивания
func _get_drag_data(_position):
	if item:
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.icon
		drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		drag_preview.custom_minimum_size = Vector2(16, 16)
		set_drag_preview(drag_preview)
		return self  # Возвращаем сам слот как drag_data
	return null

# 🏹 Когда предмет перетаскивается на другой слот
func _can_drop_data(_position, data):
	return data is InventorySlot  # Можно только между слотами

# 📦 Отпускание предмета
func _drop_data(_position, data):
	if data is InventorySlot:
		# Меняем предметы местами
		var temp_item = item
		set_item(data.item)
		data.set_item(temp_item)
