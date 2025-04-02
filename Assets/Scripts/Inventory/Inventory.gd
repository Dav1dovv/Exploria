@icon("res://IconGodotNode/control/icon_bag.png")
extends Control

class_name Inventory

@export var columns: int = 9
@export var rows: int = 3
@export var hotbar_size: int = 5
@export var player : Player
var items: Array
var hotbar_items: Array
var active_hotbar_slot: int = 0

@onready var grid = $Panel/GridContainer
@onready var hotbar_grid = $HotbarContainer
@export var initial_items: Array[ItemResource] 

const ENCRYPT_KEY = "your-secret-key-12345"  # Замените на свой ключ
const SAVE_PATH = "user://inventory_save.json"

func _ready():
	await get_tree().process_frame
	if not load_inventory():
		add_initial_items()
	# Сначала создаем все слоты
	setup_inventory()
	setup_hotbar()
	
	# Затем загружаем данные
	if not load_inventory():
		# Если загрузка не удалась, добавляем начальные предметы
		add_initial_items()
	
	set_active_slot(0)
	set_process_input(true)

# Добавление начальных предметов (переименовано)
func add_initial_items():
	for i in range(min(initial_items.size(), hotbar_items.size())):
		if initial_items[i]:
			var item = initial_items[i].duplicate()
			hotbar_items[i].set_item(item)

# Обновление выделения хотбара (переименовано)
func _update_hotbar_selection():
	for i in range(hotbar_size):
		hotbar_items[i].modulate = Color(1, 1, 1, 1)
	hotbar_items[active_hotbar_slot].modulate = Color(1, 1, 0.5, 1)

func setup_inventory():
	# Очищаем и заново создаем инвентарь
	for child in grid.get_children():
		child.queue_free()
	
	items.clear()
	
	for i in range(columns * rows):
		var slot = preload("res://Assets/Scripts/Inventory/InventorySlot.tscn").instantiate()
		grid.add_child(slot)
		items.append(slot)

func setup_hotbar():
	# Очищаем и заново создаем хотбар
	for child in hotbar_grid.get_children():
		child.queue_free()
	
	hotbar_items.clear()
	
	for i in range(hotbar_size):
		var slot = preload("res://Assets/Scripts/Inventory/InventorySlot.tscn").instantiate()
		hotbar_grid.add_child(slot)
		hotbar_items.append(slot)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_1 and event.keycode <= KEY_5:
			var index = event.keycode - KEY_1
			if index < hotbar_size:
				active_hotbar_slot = index
				_update_hotbar_selection()
				activate(index)
	if Input.is_action_just_pressed("Inventory"):
		$Panel.visible = !$Panel.visible

func activate(slot_index: int):
	if slot_index < 0 or slot_index >= hotbar_items.size():
		return
	
	var slot = hotbar_items[slot_index]
	if not slot or not slot.item:
		return
	
	print("Используем предмет:", slot.item.resource_path.get_file().get_basename())

	if slot.item.has_method("equip"):
		%weapon.update_wep(slot.item)
	elif slot.item.has_method("eat"):
		slot.item.eat(player)
		slot.item.count -= 1
		if slot.item.count <= 0:
			slot.clear_slot()
		else:
			slot.update_slot()
	#if slot.item.has_method("equip"):
		#%weapon.update_wep(slot.item)
	#elif slot.item.has_method("eat"):
		#slot.item.eat(player)
		#slot.remove_item()
	##else slot.item.has_method("use"):
		##slot.item.use()
	##else:
		##print("⚠ Ошибка! У предмета нет метода use()")

func add_item(new_item: ItemResource, amount: int = 1) -> bool:
	if not new_item or new_item.item_id.is_empty() or amount <= 0:
		return false
	
	var remaining = amount
	
	# Добавляем к существующим стакам
	if new_item.stackable:
		for slot in get_all_slots():
			if slot.item and slot.item.item_id == new_item.item_id:
				var space = slot.item.max_count - slot.item.count
				var to_add = min(space, remaining)
				slot.item.count += to_add
				slot.update_slot()
				remaining -= to_add
				if remaining <= 0:
					return true
	
	# Добавляем в пустые слоты
	for slot in get_all_slots():
		if not slot.item:
			var item_copy = new_item.duplicate()
			item_copy.count = min(item_copy.max_count, remaining)
			remaining -= item_copy.count
			slot.set_item(item_copy)
			if remaining <= 0:
				return true
	
	return remaining == 0
func find_item_by_id(item_id: String) -> ItemResource:
	# Ищем в предзагруженных предметах
	for item in initial_items:
		if item.item_id == item_id:
			return item
	
	# Ищем в загруженных ресурсах
	var item = load("res://Assets/Scripts/Inventory/Items/%s.tres" % item_id)
	if item:
		return item
	
	printerr("⚠ Предмет с ID '%s' не найден" % item_id)
	return null
# Вспомогательные методы с уникальными именами параметров
func get_all_slots() -> Array:
	return items + hotbar_items

func has_item(target_slot: InventorySlot) -> bool:
	return target_slot and target_slot.item

func add_to_existing_stack(target_slot: InventorySlot, add_amount: int) -> int:
	var available_space = target_slot.item.max_count - target_slot.item.count
	var to_add = min(available_space, add_amount)
	target_slot.item.count += to_add
	target_slot.update_slot()
	return to_add

func create_new_item_stack(target_slot: InventorySlot, source_item: ItemResource, max_amount: int) -> int:
	var new_item = source_item.duplicate()
	new_item.count = min(new_item.max_count, max_amount)
	target_slot.set_item(new_item)
	return new_item.count
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			change_hotbar_slot(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			change_hotbar_slot(1)

func change_hotbar_slot(direction: int):
	active_hotbar_slot = (active_hotbar_slot + direction) % hotbar_size
	if active_hotbar_slot < 0:
		active_hotbar_slot = hotbar_size - 1
	set_active_slot(active_hotbar_slot)

func save_inventory():
	var save_data = {
		"version": 3,
		"inventory": [],
		"hotbar": [],
		"active_slot": active_hotbar_slot
	}
	
	# Сохраняем основной инвентарь
	for slot in items:
		var slot_data = null
		if slot and slot.item:
			slot_data = {
				"item_id": slot.item.item_id,
				"count": slot.item.count
			}
		save_data["inventory"].append(slot_data)
	
	# Сохраняем хотбар
	for slot in hotbar_items:
		var slot_data = null
		if slot and slot.item:
			slot_data = {
				"item_id": slot.item.item_id,
				"count": slot.item.count
			}
		save_data["hotbar"].append(slot_data)
	
	# Сохраняем в файл
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("💾 Инвентарь сохранен")
	else:
		printerr("⚠ Ошибка при сохранении инвентаря")

func load_inventory() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()
	
	if error != OK:
		printerr("⚠ Ошибка при загрузке сохранения: ", json.get_error_message())
		return false
	
	var save_data = json.get_data()
	if not save_data or save_data.get("version", 0) != 3:
		printerr("⚠ Несовместимая версия сохранения")
		return false
	
	# Загружаем основной инвентарь
	for i in range(min(save_data["inventory"].size(), items.size())):
		var item_data = save_data["inventory"][i]
		if item_data and item_data.has("item_id"):
			var item = find_item_by_id(item_data["item_id"])
			if item:
				var item_copy = item.duplicate()
				item_copy.count = item_data.get("count", 1)
				items[i].set_item(item_copy)
	
	# Загружаем хотбар
	for i in range(min(save_data["hotbar"].size(), hotbar_items.size())):
		var item_data = save_data["hotbar"][i]
		if item_data and item_data.has("item_id"):
			var item = find_item_by_id(item_data["item_id"])
			if item:
				var item_copy = item.duplicate()
				item_copy.count = item_data.get("count", 1)
				hotbar_items[i].set_item(item_copy)
	
	# Восстанавливаем активный слот
	var saved_slot = save_data.get("active_slot", 0)
	if saved_slot >= 0 and saved_slot < hotbar_items.size():
		set_active_slot(saved_slot)
	
	print("📂 Инвентарь успешно загружен")
	return true
func create_item_from_data(data: Dictionary) -> ItemResource:
	if not data.has("resource_type"):
		return null
	
	var item: ItemResource = null
	
	# Создаем предмет нужного типа
	match data["resource_type"]:
		"WeaponResource":
			item = WeaponResource.new()
		"FoodResource":
			item = FoodResource.new()
		_:
			item = ItemResource.new()
	
	# Загружаем данные
	item.load_save_data(data)
	return item
func set_active_slot(index: int):
	if index < 0 or index >= hotbar_items.size():
		return
	
	# Сбрасываем выделение всех слотов
	for slot in hotbar_items:
		if is_instance_valid(slot):
			slot.modulate = Color.WHITE
	
	# Устанавливаем новый активный слот
	active_hotbar_slot = index
	if is_instance_valid(hotbar_items[index]):
		hotbar_items[index].modulate = Color(1, 1, 0.5)
	
	print("Активный слот установлен: ", index)
	if not FileAccess.file_exists(SAVE_PATH):
		print("ℹ️ Сохранение не найдено, создаем новый инвентарь")
		add_initial_items()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()
	
	if error != OK:
		printerr("⚠ Ошибка загрузки сохранения: ", json.get_error_message())
		add_initial_items()
		return
	
	var save_data = json.get_data()
	
	# Проверяем версию сохранения
	if save_data.get("version", 0) != 1:
		printerr("⚠ Несовместимая версия сохранения")
		add_initial_items()
		return
	
	# Загружаем основной инвентарь
	for i in range(min(save_data["inventory"].size(), items.size())):
		var item_data = save_data["inventory"][i]
		if item_data:
			var item = load(item_data["path"])
			if item:
				item = item.duplicate()
				item.count = item_data["count"]
				items[i].set_item(item)
	
	# Загружаем хотбар
	for i in range(min(save_data["hotbar"].size(), hotbar_items.size())):
		var item_data = save_data["hotbar"][i]
		if item_data:
			var item = load(item_data["path"])
			if item:
				item = item.duplicate()
				item.count = item_data["count"]
				hotbar_items[i].set_item(item)
	
	# Восстанавливаем активный слот
	var saved_slot = save_data.get("active_slot", 0)
	if saved_slot >= 0 and saved_slot < hotbar_items.size():
		active_hotbar_slot = saved_slot
		set_active_slot(active_hotbar_slot)
	
	print("📂 Инвентарь загружен")
# 🗑️ Очищаем сохранение
func clear_save():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	print("🗑️ Сохранение инвентаря удалено")


@export var autosave_interval: float = 60.0  # Автосохранение каждые 60 секунд
var autosave_timer: float = 0.0

func _process(delta):
	autosave_timer += delta
	if autosave_timer >= autosave_interval:
		save_inventory()
		autosave_timer = 0.0
