extends Entity


var mouse_pos
@onready var can_hit: CollisionShape2D = $HitPoint/Area/CollisionShape2D

enum  {Idle,Walk,Death,Jump,NON}
enum hand {Idle,Attack,Walk}
var state = Idle
var hand_state = hand.Idle
#@export var inventory: Inv

var player_anim : AnimationPlayer
var hand_anim : AnimationPlayer

var is_attacking = false
var stamina
var max_stamina = 100

@export var equip : RSC

func _ready() -> void:
	$CanvasLayer/DeathScreen.visible = false
	$CanvasLayer/HUD/HealthBar.max_value = max_hp
	$CanvasLayer/HUD/HealthBar.value = HP
	stamina = max_stamina
	update_Stamina()

func _physics_process(delta):
	mouse_pos = get_global_mouse_position()
	if player_anim != null:movement()
	if !is_attacking:$HitPoint.look_at(mouse_pos)
	$Skin/Head.look_at(mouse_pos)
	flip()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and stamina > 0:
		hand_state = hand.Attack

func movement():
	var dir = Input.get_vector("ui_left", "ui_right","ui_up", "ui_down")
	match state:
		Idle:
			##smoke.emitting = false
			if dir.x != 0 or dir.y != 0:
				state = Walk
			else :
				player_anim.play("Idle")
				pass

		Walk:
			if dir.x != 0 or dir.y != 0:
				player_anim.play("Walk")
				if mouse_pos.x > position.x:
					if dir.x > 0:
						player_anim.speed_scale = 2.5
						
					elif  dir.x < 0:
						player_anim.speed_scale = -2.5
				elif mouse_pos.x < position.x:
					if dir.x > 0:
						player_anim.speed_scale = -2.5
					elif  dir.x < 0:
						player_anim.speed_scale = 2.5
				move_and_slide()
				velocity = dir * speed * multipiler
			else :
				state = Idle
		Death:
			#queue_free()
			print("Player Died")
			###anim.play("Death")
			state = NON
	
	match hand_state:

		hand.Idle:
			hand_anim.play("Idle")
			if dir.x != 0 or dir.y != 0:
				hand_state = hand.Walk
				


		hand.Walk:
			if dir.x != 0 or dir.y != 0:
				hand_anim.play("Walk")

			elif dir.x == 0 or dir.y == 0:
				hand_state = hand.Idle
				

		hand.Attack: 
			can_hit.disabled = false
			hand_anim.play("Attack")
			await hand_anim.animation_finished
			can_hit.disabled = true
			#is_attacking =false
			hand_state = hand.Idle

func flip():
		if mouse_pos.x < global_position.x:
			$Skin.scale.x = -1
		elif mouse_pos.x > global_position.x:
			$Skin.scale.x = 1

func _on_child_entered_tree(node):
	if node.name == "Skin":
		player_anim = $Skin/AnimationPlayer
		hand_anim = $Skin/Hands/AnimationPlayer
	pass # Replace with function body.


func _on_area_area_entered(area: Area2D) -> void:
	
	if equip != null:
		if area.is_in_group("Grind"):
			area.grind(equip.damage)
		stamina -= 1
		update_Stamina()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if HP > 0: 
		take_damage(area.global_position,2)
	if HP <= 0:
		$Skin.visible = false
		$CollisionShape2D.disabled = true
		$CanvasLayer/DeathScreen.visible = true
	update_health()
	
	pass # Replace with function body.

func update_health():
	$CanvasLayer/HUD/HealthBar.max_value = max_hp
	$CanvasLayer/HUD/HealthBar.value = HP

func update_Stamina():
	$CanvasLayer/HUD/StaminaBar.max_value = max_stamina
	$CanvasLayer/HUD/StaminaBar.value = stamina
#### Effects
func heal(amount):
	HP = min(HP + amount, max_hp)
	update_health()
	print("Игрок вылечен! HP:", HP)

func increase_speed(amount):
	speed += amount
	print("Скорость увеличена! Новая скорость:", speed)

func sub_health(ammount):
	HP -= ammount
	update_health()

func add_STAMINA(ammount):
	stamina += ammount
	update_Stamina()

#func boost_damage(amount):
	#base_damage += amount
	#print("Урон увеличен! Новый урон:", base_damage)

func Equip_weapon(new_wep):
	equip = new_wep
	$"Skin/Hands/Right Hand/Weapon/Sprite2D".texture = new_wep.texture
