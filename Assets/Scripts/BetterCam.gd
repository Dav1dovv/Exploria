extends Camera2D

var sscount = 0
@export_category("Look at Mouse")
@export var look_mouse := false
@export var DeadZone = 160

func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("Screenshots")
	
	dir = DirAccess.open("user://Screenshots")
	for n in dir.get_files():
		sscount +=1

func screenshot():
	sscount = 0
	var dir = DirAccess.open("user://Screenshots")
	for n in dir.get_files():
		sscount +=1
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png("user://Screenshots/screenshot" + str(sscount) +".png")
	print("screenshot taked")

func _input(event):
	if Input.is_key_pressed(KEY_F2):
		screenshot()
	if look_mouse:
		if event is InputEventMouseMotion:
			var target = event.position - get_viewport().size * 0.5
			if target.length() < DeadZone:
				self.position = Vector2(0,0)
			else:
				self.position = target.normalized() * (target.length() - DeadZone) * 0.5
