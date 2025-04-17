# ItemResource.gd
extends Resource
class_name ItemResource

enum ItemCategory { NONE, FOOD, WEAPON, TOOL, MATERIAL }

@export var icon: Texture2D
@export var display_name: String = "Предмет"
@export_multiline var description: String = ""
@export var max_count: int = 1
@export var stackable: bool = true
@export var category: ItemCategory = ItemCategory.NONE

var count: int = 1
