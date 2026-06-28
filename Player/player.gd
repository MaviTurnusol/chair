extends CharacterBody2D

var speed = 130.0
var jumpVelocity = -440.0
@onready var anima = $Marker2D/anima
@onready var machine = $StateMachine
@onready var weaponHolder = $Marker2D/weaponHolder
var dir = 0.0

func _ready():
	UnlimitedRulebook.player = self
	
func _physics_process(delta):
	$debugState.text = str(machine.get_state())
	
	#Attacking
	if Input.is_action_just_pressed("attack"):
		if weaponHolder.get_children().size() > 0:
			if is_on_floor():
				machine.change_state_to("groundAttack")
	
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
	if Input.is_action_just_pressed("space"):
		machine.change_state_to("roll")
	
	#Movement
	var dir_ = Input.get_axis("left", "right")
	if machine.get_state() not in ["roll", "turn", "jump", 
	"fall", "fallRecovery", "groundAttack"]:
		#Turning
		if sign(dir_) == sign(-velocity.x) && dir_:
			machine.change_state_to("turn")
			dir_ = -dir_
			dir = dir_
		#Walking/Running
		if machine.get_state() not in ["turn"]:
			if dir_:
				dir = dir_
				if Input.is_action_pressed("shift"):
					velocity.x = lerp(velocity.x, dir*speed*1.6, 0.1)
					machine.change_state_to("run")
				else:
					velocity.x = lerp(velocity.x, dir*speed, 0.1)
					machine.change_state_to("walk")
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.1)
				machine.change_state_to("idle")
			
		#Flipping Sprite/Hurtbox
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
	else:
		$Marker2D/HurtBox/CollisionShape2D.set_deferred("disabled", true)
