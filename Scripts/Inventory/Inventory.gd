@icon("res://IconGodotNode/control/icon_bag.png")
extends Control

class_name Inventory

@export var columns: int = 9
@export var rows: int = 3
@export var hotbar_size: int = 5  # Количество слотов в хотбаре

var items: Array
var hotbar_items: Array  # Отдельный массив для хотбара
var active_hotbar_slot: int = 0  # Индекс активного слота

@onready var grid = $Panel/GridContainer
@onready var hotbar_grid = $HotbarContainer  # Контейнер для хотбара
func _ready():
	setup_inventory()
	setup_hotbar()
	set_process_input(true)
	set_process_unhandled_input(true)  # 🛠 Включаем обработку ввода
func setup_inventory():
	items.resize(columns * rows)
	for i in range(items.size()):
		var slot = preload("res://Scripts/Inventory/InventorySlot.tscn").instantiate()
		grid.add_child(slot)

func setup_hotbar():
	hotbar_items.resize(hotbar_size)
	for i in range(hotbar_size):
		var slot = preload("res://Scripts/Inventory/InventorySlot.tscn").instantiate()
		hotbar_grid.add_child(slot)
		hotbar_items[i] = slot  # Добавляем слот в массив

	# Выбираем первый слот
	update_hotbar_selection()

# 🔥 Переключение хотбара клавишами 1-5
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_1 and event.keycode <= KEY_5:
			var index = event.keycode - KEY_1
			if index < hotbar_size:
				active_hotbar_slot = index
				update_hotbar_selection()
				activate(index)
	if Input.is_action_just_pressed("Inventory"):
		$Panel.visible = !$Panel.visible
# 🔥 Подсвечиваем активный слот
func update_hotbar_selection():
	for i in range(hotbar_size):
		hotbar_items[i].modulate = Color(1, 1, 1, 1)
	hotbar_items[active_hotbar_slot].modulate = Color(1, 1, 0.5, 1)


func activate(slot_indx):
		var slot = hotbar_items[active_hotbar_slot]
		if slot == null:
			print("⛔ Ошибка: слот не найден!")
			return

		if slot.item == null:
			print("⛔ Ошибка: предмета в слоте нет!")
			return

		print("🎯 Используем предмет:", slot.item.resource, " | Класс: ", slot.item.get_class())
		if slot.item.has_method("use"):
			slot.item.use()
		elif slot.item.has_method("equip"):
			%weapon.update_wep(slot.item)
		else:
			print("⚠ Ошибка! У предмета нет метода use()")


func add_item(item: RSC, amount: int):
	var remaining = amount
	
	# Добавляем в существующие стаки
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
	
	# Добавляем в пустые слоты
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
