@icon("res://IconGodotNode/control/icon_bell.png")
extends Control

@export var max_notifications: int = 5  # Максимум уведомлений на экране
@onready var vbox = $VBoxContainer  # Контейнер для уведомлений

# Функция добавления нового уведомления с иконкой
func show_notification(text: String, duration: float = 3.0, icon: Texture = null):
	var hbox = HBoxContainer.new()  # Контейнер для иконки и текста
	hbox.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	vbox.add_child(hbox)

	# Добавляем иконку, если она есть
	if icon:
		var icon_texture = TextureRect.new()
		icon_texture.texture = icon
		icon_texture.custom_minimum_size = Vector2(32, 32)  # Размер иконки
		icon_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hbox.add_child(icon_texture)

	# Добавляем текст
	var label = Label.new()
	label.text = text
	label.modulate = Color(1, 1, 1, 0)  # Прозрачность в начале
	hbox.add_child(label)

	# Анимация появления
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color(1, 1, 1, 1), 0.5)

	# Запускаем таймер на удаление
	await get_tree().create_timer(duration).timeout

	# Проверяем, существует ли уведомление перед удалением
	if is_instance_valid(hbox):
		remove_notification(hbox)

# Функция удаления уведомления
func remove_notification(notification):
	if notification and is_instance_valid(notification) and notification in vbox.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(notification, "modulate", Color(1, 1, 1, 0), 0.5)
		await tween.finished

		# Проверяем перед удалением
		if is_instance_valid(notification):
			notification.queue_free()

	# Ограничиваем количество сообщений
	if vbox.get_child_count() > max_notifications:
		var oldest = vbox.get_child(0)
		if is_instance_valid(oldest):
			remove_notification(oldest)
