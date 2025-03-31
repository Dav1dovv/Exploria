extends Node

const SAVE_PATH = "user://inventory_save.exploria"

func save_game(inventory: Inventory):
	var save_data = inventory.save_inventory()
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("💾 Инвентарь сохранён. Сохранено предметов: ", 
			  save_data["inventory_items"].size() + save_data["hotbar_items"].size())

func load_game(inventory: Inventory) -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("ℹ️ Файл сохранения не найден, будет создан новый инвентарь")
		return false
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("⛔ Ошибка загрузки сохранения: %s" % FileAccess.get_open_error())
		return false
	
	var save_data = file.get_var()
	file.close()
	
	if save_data is Dictionary:
		inventory.load_inventory(save_data)
		return true
	
	push_error("⛔ Неверный формат сохранения")
	return false
