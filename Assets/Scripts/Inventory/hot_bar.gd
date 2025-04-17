extends HBoxContainer
class_name Hotbar

@onready var inventory: Inventory = get_parent()  # Adjust path to your Inventory node
var hotbar_slots: Array[Dictionary] = []  # Stores {item: ItemResource, slot: InventorySlot}
const HOTBAR_SIZE: int = 9  # Number of hotbar slots
var slot_scene = preload("res://Assets/Scripts/Inventory/InventorySlot.tscn")
var selected_slot: int = 0  # Currently selected hotbar slot (0-based index)

signal item_used(item: ItemResource, amount: int)

func _ready() -> void:
	# Initialize hotbar slots with existing slots
	for slot in get_children():
		if slot is TextureButton:
			hotbar_slots.append({"item": slot.item, "slot": slot})
			slot.pressed.connect(_on_slot_pressed.bind(hotbar_slots.size() - 1))
	# Rest of the _ready() code...
	
	# Sync with inventory (assume first HOTBAR_SIZE slots of inventory are hotbar)
	if inventory and inventory.items.size() >= HOTBAR_SIZE:
		for i in range(HOTBAR_SIZE):
			var inv_slot = inventory.items[i].slot
			hotbar_slots[i].item = inv_slot.item
			hotbar_slots[i].slot.item = inv_slot.item
			hotbar_slots[i].slot.ammount = inv_slot.ammount
			hotbar_slots[i].slot.update_ui()
	
	# Connect to inventory's changed signal
	if inventory:
		inventory.inventory_changed.connect(_on_inventory_changed)
	
	# Highlight the initially selected slot
	_update_slot_highlight()

func _input(event: InputEvent) -> void:
	# Handle number keys (1-9) for slot selection
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var index = event.keycode - KEY_1
			if index < HOTBAR_SIZE:
				select_slot(index)
	
	# Handle mouse wheel for slot cycling
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			select_slot((selected_slot - 1 + HOTBAR_SIZE) % HOTBAR_SIZE)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			select_slot((selected_slot + 1) % HOTBAR_SIZE)
	
		# Consume FoodResource with left mouse button
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_slot >= 0 and selected_slot < hotbar_slots.size():
			var slot = hotbar_slots[selected_slot].slot
			if slot.item and slot.item is FoodResource:
				_use_item(slot.item, slot.ammount)
			else:
				print("No food item in active slot")
	# Use item in the active slot
	#if event.is_action_pressed("use_item"):
		#if selected_slot >= 0 and selected_slot < hotbar_slots.size():
			#var slot = hotbar_slots[selected_slot].slot
			#if slot.item:
				#_use_item(slot.item, slot.ammount)
			#else:
				#print("No item in active slot")

func select_slot(index: int) -> void:
	if index >= 0 and index < HOTBAR_SIZE:
		selected_slot = index
		_update_slot_highlight()
	if selected_slot >= 0 and selected_slot < hotbar_slots.size():
		var slot = hotbar_slots[selected_slot].slot
		if slot.item and slot.item is not FoodResource:
			_use_item(slot.item, slot.ammount)
		else:
			print("No item in active slot")


func _update_slot_highlight() -> void:
	for i in range(HOTBAR_SIZE):
		var slot = hotbar_slots[i].slot
		slot.modulate = Color(1, 1, 1, 1) if i == selected_slot else Color(0.7, 0.7, 0.7, 1)

func _on_slot_pressed(index: int) -> void:
	select_slot(index)

func _use_item(item: ItemResource, amount: int) -> void:
	emit_signal("item_used", item, amount)
	if item is WeaponResource:
		item.equip()
		get_tree().get_first_node_in_group("Equip").Equip_item(item)
	elif item is FoodResource:
		var player = get_tree().get_first_node_in_group("Player")  # Adjust path to your Player node
		if player:
			get_tree().get_first_node_in_group("Equip").Equip_item(item)
			item.eat(player)
			inventory.remove_item(item, 1)
			print("Consumed food: ", item.display_name)
	else:
		print("Cannot use item: ", item.display_name)


func _on_inventory_changed() -> void:
	if inventory and inventory.items.size() >= HOTBAR_SIZE:
		for i in range(HOTBAR_SIZE):
			var inv_slot = inventory.items[i].slot
			hotbar_slots[i].item = inv_slot.item
			hotbar_slots[i].slot.item = inv_slot.item
			hotbar_slots[i].slot.ammount = inv_slot.ammount
			hotbar_slots[i].slot.update_ui()

func update() -> void:
	for entry in hotbar_slots:
		var slot = entry.slot
		slot.update_ui()
