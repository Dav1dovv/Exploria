extends Control
class_name Inventory

@onready var grid_container: GridContainer = $Panel/GridContainer
var items: Array[Dictionary] = []  # Stores {item: ItemResource, slot: InventorySlot}
signal inventory_changed

# Preload initial tools
var pickaxe_resource = preload("res://Assets/Scripts/Inventory/Weapons/MGM.tres")
var sword_resource = preload("res://Assets/Scripts/Inventory/Weapons/Simple Sword.tres")

const  SAVE_PATH = "user://Saves/inventory_save.json"

func _ready() -> void:
	# Initialize items array with existing slots in GridContainer
	for slot in grid_container.get_children():
		if slot is TextureButton:  # Ensure the child is an InventorySlot
			items.append({"item": slot.item, "slot": slot})
	if items.size() == 0:
		print("Warning: No inventory slots found in GridContainer")

	# Load inventory or add initial tools for new game
	if FileAccess.file_exists(SAVE_PATH):
		load_inventory()
	else:
		add_initial_tools()

func add_initial_tools() -> void:
	# Add starting tools
	add_item(pickaxe_resource, 1)
	add_item(sword_resource, 1)
	print("Added initial tools: Pickaxe and Basic Sword")

func add_item(item: ItemResource, amount: int) -> void:
	if amount <= 0:
		print("Error: Cannot add non-positive amount of items")
		return

	if item.stackable:
		for entry in items:
			if entry.item and entry.item.display_name == item.display_name:
				var slot = entry.slot
				var current_amount = slot.ammount
				var space_left = item.max_count - current_amount
				if space_left > 0:
					var amount_to_add = min(amount, space_left)
					slot.add_ammount(amount_to_add)
					amount -= amount_to_add
					slot.update_ui()
					if amount == 0:
						emit_signal("inventory_changed")
						return

	for entry in items:
		if entry.item == null:
			var slot = entry.slot
			var new_item = item.duplicate()
			new_item.count = min(amount, new_item.max_count)
			slot.item = new_item
			slot.set_ammount(new_item.count)
			slot.update_ui()
			entry.item = new_item
			amount -= new_item.count
			if amount == 0:
				emit_signal("inventory_changed")
				return
			break

	if amount > 0:
		Notification.show_notification("Warning: Inventory full, cannot add " + str(amount) + " of "+ item.display_name,5.0,null)
		print("Warning: Inventory full, cannot add ", amount, " of ", item.display_name)

func remove_item(item: ItemResource, amount: int) -> void:
	if amount <= 0:
		print("Error: Cannot remove non-positive amount of items")
		return

	var remaining = amount
	for entry in items:
		if entry.item and entry.item.display_name == item.display_name:
			var slot = entry.slot
			var current_amount = slot.ammount
			var amount_to_remove = min(remaining, current_amount)
			slot.sub_ammount(amount_to_remove)
			remaining -= amount_to_remove
			if slot.ammount <= 0:
				slot.item = null
				entry.item = null
			slot.update_ui()
			if remaining == 0:
				break

	if remaining > 0:
		print("Warning: Not enough ", item.display_name, " to remove (missing ", remaining, ")")
	emit_signal("inventory_changed")

func update() -> void:
	for entry in items:
		var slot = entry.slot
		slot.update_ui()

func clear_inventory() -> void:
	for entry in items:
		var slot = entry.slot
		slot.item = null
		slot.set_ammount(0)
		entry.item = null
		slot.update_ui()
	emit_signal("inventory_changed")

func get_item_count(item_name: String) -> int:
	var total: int = 0
	for entry in items:
		if entry.item and entry.item.display_name == item_name:
			total += entry.slot.ammount
	return total

func has_item(item: ItemResource, amount: int) -> bool:
	return get_item_count(item.display_name) >= amount

func save_inventory() -> void:
	var save_data: Array = []
	for entry in items:
		var slot = entry.slot
		var item_data = {}
		if slot.item:
			item_data = {
				"display_name": slot.item.display_name,
				"count": slot.ammount,
				"max_count": slot.item.max_count,
				"stackable": slot.item.stackable,
				"category": slot.item.category,
				"icon_path": slot.item.icon.resource_path if slot.item.icon else "",
				"description": slot.item.description,
				"type": "ItemResource"
			}
			if slot.item is WeaponResource:
				item_data.type = "WeaponResource"
				item_data.types = slot.item.types
				item_data.damage_strength = slot.item.damage_strength
				item_data.hit_distance = slot.item.hit_distance
				item_data.projectile_path = slot.item.projectile.resource_path if slot.item.projectile else ""
				item_data.hit_effect = []  # Simplified; extend if effects are serializable
			elif slot.item is FoodResource:
				item_data.type = "FoodResource"
				item_data.effects = []  # Simplified; extend if effects are serializable
		save_data.append(item_data)

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("Inventory saved to user://inventory_save.json")
	else:
		print("Error: Failed to save inventory")

func load_inventory() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		print("Error: Failed to open save file")
		return

	var json_text = file.get_as_text()
	file.close()
	var json = JSON.new()
	var error = json.parse(json_text)
	if error != OK:
		print("Error: Failed to parse JSON - ", json.get_error_message())
		return

	var save_data = json.get_data()
	if not save_data is Array:
		print("Error: Invalid save data format")
		return

	clear_inventory()  # Clear current inventory before loading
	for i in range(min(save_data.size(), items.size())):
		var item_data = save_data[i]
		if item_data.is_empty():
			continue

		var item: ItemResource
		if item_data.type == "WeaponResource":
			item = WeaponResource.new()
			item.types = item_data.types
			item.damage_strength = item_data.damage_strength
			item.hit_distance = item_data.hit_distance
			if item_data.projectile_path:
				item.projectile = load(item_data.projectile_path)
		elif item_data.type == "FoodResource":
			item = FoodResource.new()
			# Add effects loading if needed
		else:
			item = ItemResource.new()

		item.display_name = item_data.display_name
		item.count = item_data.count
		item.max_count = item_data.max_count
		item.stackable = item_data.stackable
		item.category = item_data.category
		item.description = item_data.description
		if item_data.icon_path:
			item.icon = load(item_data.icon_path)

		var slot = items[i].slot
		slot.item = item
		slot.set_ammount(item_data.count)
		items[i].item = item
		slot.update_ui()

	emit_signal("inventory_changed")
	print("Inventory loaded from user://inventory_save.json")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory"):
		$Panel.visible = !$Panel.visible
		#$HotBar.visible = !$HotBar.visible
