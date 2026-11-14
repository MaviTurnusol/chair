@icon("uid://bq0j64m8a0ocr")
extends CharacterBody2D
class_name Player
var speed = 100.0
var jumpVelocity = -440.0
@onready var anima = $Marker2D/anima
@onready var machine = $StateMachine
#@onready var weaponHolder = $Marker2D/weaponHolder
@onready var marker_2d: Marker2D = $Marker2D
@onready var wall_check: RayCast2D = $Marker2D/WallCheck

@onready var inventory_component: InventoryComponent = $PlayerInventory/PlayerInventoryComponent
@onready var player_inventory: Node = $PlayerInventory
@onready var inventory_mator := $PlayerInventory/PlayerInventoryDisplayer/AnimationPlayer

var dir = 1.0

var weapon_equipped = false
var weapon : Node2D

var locked_in = false

func _ready() -> void:
	UnlimitedRulebook.player = self
	SceneManager.setplayerposition.connect(SetGlobalPosition)

func SetGlobalPosition(WhatPosition : Vector2):
	global_position = WhatPosition

func CheckIfMovingNearWall()->bool:
	if(wall_check.is_colliding()):
		return true
	else:
		return false
	

func _physics_process(delta):
	$debugState.text = str(machine.get_state())
	
	if(machine.get_state()=="hurt"):
		return
	##Attacking
	#if Input.is_action_just_pressed("attack"):
		#if weaponHolder.get_children().size() > 0:
			#if is_on_floor():
				#machine.change_state_to("groundAttack")
	
	#Jumping
	if Input.is_action_just_pressed("jump"):
		machine.change_state_to("jump")
	
	#Falling
	if !is_on_floor():
		#idk if we really need this
		if machine.get_state() not in ["jump"]:
			machine.change_state_to("fall")
			velocity.y += get_gravity().y * delta * 1.66
		else:
			velocity.y += get_gravity().y * delta * 1.33
	
	#Rolling
	if Input.is_action_just_pressed("roll"):
		machine.change_state_to("roll")

	#Parry
	if(Input.is_action_just_pressed("Parry")):
		machine.change_state_to("parry")

	#Inventory Toggle
	if(Input.is_action_just_pressed("InventoryToggle")) && !inventory_mator.is_playing():
		player_inventory.ToggleInventory()
	
	#Gun
	if Input.is_action_just_pressed("equip"):
		if !weapon_equipped:
			weapon_equipped = true
			$IKArmPlayer.state = $IKArmPlayer.STATES.LARP_CURSOR
			machine.change_state_to("gunWalk")
		else:
			weapon_equipped = false
			if machine.get_state() in ["gunIdle", "gunWalk"]:
				machine.change_state_to("idle")
	
	if machine.get_state() in ["gunIdle", "gunWalk"]:
		$IKArmPlayer.visible = true
	else:
		$IKArmPlayer.visible = false
	
	#Movement
	var dir_ = Input.get_axis("left", "right")
	if machine.get_state() not in ["roll", "turn", "jump", 
	"fall", "fallRecovery", "groundAttack", "talk", "cutscene", "gunWalk", "gunIdle","meleeAttack"
	,"hook","parry","vineExit","vining"]:
		#Turning
		if UnlimitedRulebook.lockedEnemyPosition == Vector2(0, 0):
			if(dir_):
				if(sign(dir_)!= sign(dir)):
					machine.change_state_to("turn")
					dir_ = -dir_
					dir = dir_
			#if sign(dir_) == sign(-velocity.x) && dir_:
				#

		#Walking/Running
		if machine.get_state() not in ["turn"]:
			if dir_:
				dir = dir_
				if weapon_equipped:
					machine.change_state_to("gunWalk")
				if Input.is_action_pressed("shift"):
					#moved to state
					#velocity.x = lerp(velocity.x, dir*speed*1.6, 0.1)
					machine.change_state_to("run")
				else:
					#moved to state
					#velocity.x = lerp(velocity.x, dir*speed, 0.1)
					machine.change_state_to("walk")
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.1)
				if !weapon_equipped:
					machine.change_state_to("idle")
				else:
					machine.change_state_to("gunIdle")
					
		#Flipping Sprite/Hurtbox
		if !(UnlimitedRulebook.lockedEnemyPosition == Vector2(0, 0) && machine.get_state() in ["walk", "gunWalk", "idle"]):
			if Input.is_action_pressed("left"):
				flip("left")
			elif Input.is_action_pressed("right"):
				flip("right")

func flip(foo) -> void:
	match foo:
		"left":
			$Marker2D.scale.x = -1
		"right":
			$Marker2D.scale.x = 1

func set_collisions(foo) -> void:
	#not actually collision but the hurtbox, i got lazy to rename this
	if foo:
		$Marker2D/HurtBox/CollisionShape2D.set_deferred("disabled", false)
		$ActionableFinder/CollisionShape2D.set_deferred("disabled",false)
	else:
		$Marker2D/HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$ActionableFinder/CollisionShape2D.set_deferred("disabled",true)
	
	#actual collisions???
	set_collision_layer_value(1, foo)
	set_collision_mask_value(1, foo)
	set_collision_layer_value(3, !foo)
	set_collision_mask_value(3, !foo)

func StartVenting():
	#state = STATES.VENTING
	machine.change_state_to("vining")
	pass
func StopVenting(WhereExit): #VECTOR2 in global
	if(WhereExit != null):
		global_position = WhereExit - Vector2(0,-16) #Vector2(0,($Marker2D/anima.sprite_frames.get_frame_texture($Marker2D/anima.animation,$Marker2D/anima.frame).get_height()/6))
		machine.change_state_to("vineExit")
	else:
		machine.change_state_to("vineExit")
		machine.change_state_to("idle")
	#state = STATES.LEAVEVENT
	pass

@export var KnockedbackAmount : float = 5
@export var KnockbackDuration : float = 1
const kb_check_offset = Vector2(0,-25)
var attackerDir
var KBTween : Tween
func knockback(attacker:Node2D):
	attackerDir = sign(global_position.x - attacker.global_position.x)
	
	var TargetPointRay : RayCast2D = RayCast2D.new()
	UnlimitedRulebook.currentScene.add_child(TargetPointRay)
	TargetPointRay.global_position = global_position + kb_check_offset
	TargetPointRay.collision_mask = 4
	TargetPointRay.target_position = Vector2.ZERO
	TargetPointRay.target_position.x = sign(global_position.x-attacker.global_position.x)
	
	if(TargetPointRay.target_position == Vector2(0,0)):
		TargetPointRay.target_position.x += 1
	
	TargetPointRay.target_position *= KnockedbackAmount
	
	TargetPointRay.force_raycast_update()
	
	var TargetPoint : Vector2
	if(TargetPointRay.is_colliding()):
		TargetPoint = TargetPointRay.get_collision_point()
	else:
		TargetPoint = TargetPointRay.global_position + TargetPointRay.target_position
	TargetPoint -= kb_check_offset
	KBTween = get_tree().create_tween()
	KBTween.set_ease(Tween.EASE_OUT)
	KBTween.set_trans(Tween.TRANS_CUBIC)
	KBTween.tween_property(self,"global_position",TargetPoint,KnockbackDuration)
	
	machine.change_state_to("hurt")

func death():
	queue_free()
