@icon("res://IconGodotNode/node_2D/icon_human_controller.png")
extends BaseEntity
class_name Player

@onready var attack_point: Node2D = $Skin/Body/Hands/AttackPoint

var dir :Vector2
var mouse_look
var is_attack :bool = false
enum hand {Idle,Attack,Walk}
var hand_state = hand.Idle

var max_stamina = 100
var stamina

func _ready() -> void:
	print(max_hp)
	hp = max_hp
	stamina = max_stamina
	$CanvasLayer/HUD/HealthBar.init_bar(max_hp)
	$CanvasLayer/HUD/StaminaBar.init_bar(max_stamina)
	$CanvasLayer/HUD/StaminaBar.init_bar(stamina)
	stamina_update()
	

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	#movement
	mouse_look = get_global_mouse_position()
	dir = Input.get_vector("Left","Right","Up","Down")
	
	attack_point.look_at(mouse_look)
	move_and_slide()
	#flip
	if mouse_look.x > position.x:
		# skin looking left
		$Skin.scale.x = scale.x
		pass
	elif mouse_look.x < position.x:
		# skin looking right
		$Skin.scale.x = -scale.x
		pass
	
	#animation
	if dir.x != 0 or dir.y != 0:
		#can walk
		if Input.is_action_pressed("Dash"):
			$Skin/AnimationPlayer.play("Run")
			$Skin/AnimationPlayer.speed_scale = 1.5
			velocity = dir * speed * 25
		else:
			$Skin/AnimationPlayer.play("Walk")
			$Skin/AnimationPlayer.speed_scale = 1.0
			velocity = dir * speed * 10
		pass
	else:
		#cant walk
		$Skin/AnimationPlayer.play("Idle")
		velocity = dir
		pass
	
	#attack
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !is_attack and stamina > 0:
		print("attack")
		$Skin/Body/Hands/AnimationPlayer.play("Attack")
		is_attack = true
		await $Skin/Body/Hands/AnimationPlayer.animation_finished
		is_attack = false
	if $CanvasLayer/HUD/DebugUI.visible:
		$CanvasLayer/HUD/DebugUI/Label.text = "FPS: " + str(Engine.get_frames_per_second())
	
	update_health()
func _on_hurt_box_area_entered(area: Area2D) -> void:
	var e = area.get_parent()
	take_damage(e.global_position,e.damage_strenght,null)
	$CanvasLayer/HUD/HealthBar.update_bar(hp)
	
func stamina_update():
	$CanvasLayer/HUD/StaminaBar.update_bar(stamina)

func update_health():
	$CanvasLayer/HUD/HealthBar.update_bar(hp)
	

func _on_timer_timeout() -> void:
	stamina -= 1
	stamina_update()
	$Timer.start()
