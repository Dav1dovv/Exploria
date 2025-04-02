extends Resource
class_name ItemResource

@export var item_id: String = ""  # Уникальный идентификатор
@export var display_name: String = "Предмет"
@export_multiline var description: String = ""
@export var icon: Texture2D
@export var max_count: int = 1
@export var stackable: bool = true

var count: int = 1

# Функция для получения данных сохранения
func get_save_data() -> Dictionary:
	return {
		"item_id": item_id,
		"display_name": display_name,
		"description": description,
		"count": count,
		"max_count": max_count,
		"stackable": stackable,
		"resource_type": get_class()
	}

# Функция загрузки данных
func load_save_data(data: Dictionary) -> void:
	if data.has("item_id"): item_id = data["item_id"]
	if data.has("display_name"): display_name = data["display_name"]
	if data.has("description"): description = data["description"]
	if data.has("count"): count = data["count"]
	if data.has("max_count"): max_count = data["max_count"]
	if data.has("stackable"): stackable = data["stackable"]
