@icon("res://IconGodotNode/control/icon_beetle.png")
extends Control

@export var command_prefix = ":"

var commands = {}

@onready var input_field = $LineEdit
@onready var output_field = $RichTextLabel

func _ready():
	# Подключаем событие ввода
	if input_field:
		print("✅ input_field найден!")
		input_field.connect("text_submitted", Callable(self, "_on_text_entered"))
	else:
		print("❌ input_field НЕ найден! Проверь путь в сцене.")
	# Регистрируем команды
	commands = {
		"help": func(args: Array) -> void:
			print_help(),
		"echo": func(args: Array) -> void:
			echo_command(args),
		"clear": func(args: Array) -> void:
			clear_command(),
		"add_health": func(args: Array) -> void:
			add_health(args),
		"sub_health": func(args: Array) -> void:
			sub_health(args),
		"add_item": func(args: Array) -> void:
			add_item_command(args),
		"remove_item": func(args: Array) -> void:
			remove_item_command(args),
	}

func _on_text_entered(new_text: String) -> void:
	input_field.text = ""  # Очищаем поле ввода
	if new_text.begins_with(command_prefix):
		var command_line = new_text.substr(command_prefix.length()).strip_edges()
		execute_command(command_line)
	else:
		append_output(new_text + "\n", Color(1, 1, 1))  # Белый текст

func execute_command(command_line: String) -> void:
	var tokens = command_line.split(" ")
	var command = tokens[0].to_lower()
	var args = tokens.slice(1)
	
	if command in commands:
		commands[command].call(args)
	else:
		append_output("Unknown command: " + command + "\n", Color(1, 0, 0))  # Красный для ошибок

# ======= ОПИСАНИЕ КОМАНД =======

func print_help() -> void:
	append_output("Available commands:\n", Color(1, 1, 1))
	for command in commands.keys():
		append_output(" - " + command + "\n", Color(1, 1, 1))

func echo_command(args: Array) -> void:
	append_output("Echo: " + array_to_string(args, " ") + "\n", Color(1, 1, 1))

func clear_command() -> void:
	output_field.clear()

func sub_health(args: Array) -> void:
	if args.size() == 1 and args[0].is_valid_int():
		var amount = int(args[0])
		get_tree().get_first_node_in_group("Player").sub_health(amount)
		append_output("Decreased health by " + str(amount) + "\n", Color(1, 1, 0))
	else:
		append_output("Usage: :decrease_health <amount>\n", Color(1, 0, 0))

func add_health(args: Array) -> void:
	if args.size() == 1 and args[0].is_valid_int():
		var amount = int(args[0])
		get_tree().get_first_node_in_group("Player").heal(amount)
		append_output("Increased health by " + str(amount) + "\n", Color(1, 1, 0))
	else:
		append_output("Usage: :increase_health <amount>\n", Color(1, 0, 0))

func add_item_command(args: Array) -> void:
	if args.size() < 1 or args.size() > 2:
		append_output("Usage: :add_item <item_name> [quantity]\n", Color(1, 0, 0))
		return
	
	var item_name = args[0]
	var quantity = 1 if args.size() == 1 else int(args[1])

	var inventory = get_tree().get_first_node_in_group("Inventory")
	if inventory:
		var item_res = load("res://Inv/items/" + item_name + ".tres")  # Загружаем ресурс предмета
		if item_res:
			var success = inventory.add_item(item_res, quantity)
			if success:
				append_output("Added " + str(quantity) + " of " + item_name + " to inventory.\n", Color(1, 1, 0))
			else:
				append_output("No space in inventory!\n", Color(1, 0, 0))
		else:
			append_output("Item " + item_name + " not found.\n", Color(1, 0, 0))
	else:
		append_output("Inventory not found.\n", Color(1, 0, 0))

func remove_item_command(args: Array) -> void:
	if args.size() != 2 or not args[1].is_valid_int():
		append_output("Usage: :remove_item <slot_index> <quantity>\n", Color(1, 0, 0))
		return

	var index = int(args[0])
	var quantity = int(args[1])
	var inventory = get_tree().get_first_node_in_group("Inventory")

	if inventory:
		if index >= 0 and index < inventory.size:
			var success = inventory.remove_item(index, quantity)
			if success:
				append_output("Removed " + str(quantity) + " items from slot " + str(index) + ".\n", Color(1, 1, 0))
			else:
				append_output("No item to remove at slot " + str(index) + ".\n", Color(1, 0, 0))
		else:
			append_output("Invalid slot index.\n", Color(1, 0, 0))
	else:
		append_output("Inventory not found.\n", Color(1, 0, 0))

# ======= ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =======

func append_output(message: String, color: Color) -> void:
	var color_str = ColorToHex(color)
	output_field.append_text("[color=" + color_str + "]" + message + "[/color]\n")
	output_field.scroll_to_line(output_field.get_line_count() - 1)

func ColorToHex(color: Color) -> String:
	return "#%02X%02X%02X" % [int(color.r * 255), int(color.g * 255), int(color.b * 255)]

func array_to_string(arr: Array, delimiter: String) -> String:
	return delimiter.join(arr)

func _input(event):
	if Input.is_key_pressed(KEY_F6):
		visible = !visible  # Переключаем видимость консоли
		if visible:
			input_field.grab_focus()  # Фокус на поле ввода
		else:
			input_field.release_focus()  # Убираем фокус
