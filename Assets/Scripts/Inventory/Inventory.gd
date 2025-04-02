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
@export var initial_items: Array[RSC] 
const SAVE_PATH = "user://inventory_save.json"

func _ready():
	setup_inventory()
	setup_hotbar()
	_add_initial_items()  # Переименовал функцию, чтобы избежать конфликта
	_update_hotbar_selection()  # Переименовал функцию
	set_process_input(true)
	set_process_unhandled_input(true)
	set_active_slot(0)

# Добавление начальных предметов (переименовано)
func _add_initial_items():
	for i in range(min(hotbar_size, initial_items.size())):
		if initial_items[i] != null:
			var slot = hotbar_items[i]
			slot.set_item(initial_items[i].duplicate())
			print("🔥 Добавлен начальный предмет:", initial_items[i].resource, "в слот", i)

# Обновление выделения хотбара (переименовано)
func _update_hotbar_selection():
	for i in range(hotbar_size):
		hotbar_items[i].modulate = Color(1, 1, 1, 1)
	hotbar_items[active_hotbar_slot].modulate = Color(1, 1, 0.5, 1)

func setup_inventory():
	items.resize(columns * rows)
	for i in range(items.size()):
		var slot = preload("res://Assets/Scripts/Inventory/InventorySlot.tscn").instantiate()
		grid.add_child(slot)

func setup_hotbar():
	hotbar_items.resize(hotbar_size)
	for i in range(hotbar_size):
		var slot = preload("res://Assets/Scripts/Inventory/InventorySlot.tscn").instantiate()
		hotbar_grid.add_child(slot)
		hotbar_items[i] = slot

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

func activate(slot_indx):
	var slot = hotbar_items[active_hotbar_slot]
	if slot == null:
		print("⛔ Ошибка: слот не найден!")
		return

	if slot.item == null:
		print("⛔ Ошибка: предмета в слоте нет!")
		return

	print("🎯 Используем предмет:", slot.item.resource, " | Класс: ", slot.item.get_class())

	if slot.item.has_method("equip"):
		%weapon.update_wep(slot.item)
	elif slot.item.has_method("eat"):
		slot.item.eat(player)
		slot.item.count -= 1  # Уменьшаем количество напрямую
		if slot.item.count <= 0:
			slot.set_item(null)  # Очищаем слот если предмет закончился
		else:
			slot.update_slot()  # Обновляем отображение количества
	else:
		print("⚠ Ошибка! У предмета нет метода use()")
	#if slot.item.has_method("equip"):
		#%weapon.update_wep(slot.item)
	#elif slot.item.has_method("eat"):
		#slot.item.eat(player)
		#slot.remove_item()
	##else slot.item.has_method("use"):
		##slot.item.use()
	##else:
		##print("⚠ Ошибка! У предмета нет метода use()")

func add_item(item: RSC, amount: int):
	var remaining = amount
	
	for i in range(items.size()):
		if items[i] != null and items[i].resource == item.resource:
			var free_space = items[i].max_count - items[i].count
			var to_add = min(free_space, remaining)
			items[i].count += to_add
			remaining -= to_add
			var slot = grid.get_child(i)
			slot.set_item(items[i])
			if remaining <= 0:
				return true
	
	for i in range(items.size()):
		if items[i] == null:
			var new_item = item.duplicate()
			new_item.count = min(new_item.max_count, remaining)
			remaining -= new_item.count
			items[i] = new_item
			var slot = grid.get_child(i)
			slot.set_item(new_item)
			if remaining <= 0:
				return true
	
	return remaining == 0

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

func set_active_slot(index: int):
	for i in range(hotbar_size):
		var slot = hotbar_grid.get_child(i)
		slot.modulate = Color(1, 1, 1, 1) if i == index else Color(0.7, 0.7, 0.7, 1)
	activate(index)
	print("🎯 Активный слот:", index)
