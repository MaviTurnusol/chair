extends Node2D

#STATES
var CurrentState : States = States.Idle:
	set(value):
		StateChanged(CurrentState,value)
		CurrentState = value
enum States{
	Idle,
	Chasing,
	AttackWinding,
	Attacking,
	AttackRecovery,
	Stunned,
}

@export var ChaseSpeed : float = 5
@export var KnockedbackAmount : float = 5
@export var StaggerDuration : float = 1

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var attack_zone: Area2D = $AttackZone
@onready var aggro_zone: Area2D = $AggroZone
var AggroTarget : Node2D
var WalkDirection : int = 0
#Knockback
var KnockbackTargetPoint : Vector2
var PointAtWhichWasKnockedBack : Vector2

@export_category("Attacks")
@export var AttacKDMG : int = 1
@export var MoveWhileWinding : bool = false
@export var SpeedWhileWinding : float = 15
@export var AttacKWindUpTime : int = 1
@export var AttackHoldTime : float = 0.25
@export var AttacKRecoveryTime : int = 1
var istargetinattackrange : bool = false
func StateChanged(_OldState : States,NewState : States):
	match NewState:
		States.Chasing:
			if(istargetinattackrange):
				CurrentState = States.AttackWinding
				return
			sprite.play("walk")
		States.AttackWinding:
			sprite.play("windup")
			await get_tree().create_timer(AttacKWindUpTime).timeout
			CurrentState = States.Attacking
		States.Attacking:
			sprite.play("attack")
			await get_tree().create_timer(AttackHoldTime).timeout
			CurrentState = States.AttackRecovery
		States.AttackRecovery:
			sprite.play("recovery")
			await get_tree().create_timer(AttacKRecoveryTime).timeout
			CurrentState = States.Chasing

func death():
	queue_free()

func _ready() -> void:
	aggro_zone.body_entered.connect(BodyEnteredAggroZone)
	attack_zone.body_entered.connect(BodyEnteredAttackZone)
	attack_zone.body_exited.connect(BodyExitedAttackZone)

func _process(delta: float) -> void:
	if(CurrentState == States.Chasing):
		if(AggroTarget):
			if(AggroTarget.global_position.x<global_position.x):
				if(WalkDirection!=-1):
					ChangeDirection(-1)
			if(AggroTarget.global_position.x>global_position.x):
				if(WalkDirection!=1):
					ChangeDirection(1)
		if(!istargetinattackrange):
			position.x += ChaseSpeed*delta*WalkDirection
	
	if(MoveWhileWinding):
		if(CurrentState == States.AttackWinding):
			if(AggroTarget):
				if(AggroTarget.global_position.x<global_position.x):
					if(WalkDirection!=-1):
						ChangeDirection(-1)
				if(AggroTarget.global_position.x>global_position.x):
					if(WalkDirection!=1):
						ChangeDirection(1)
			
			position.x += SpeedWhileWinding*delta*WalkDirection
	
	if(CurrentState == States.Stunned):
		position = position.move_toward(PointAtWhichWasKnockedBack+KnockbackTargetPoint,KnockedbackAmount/StaggerDuration*delta)

func BodyEnteredAggroZone(body : Node2D):
	if(CurrentState != States.Idle):
		return
	if(body.is_in_group("player")):
		AggroTarget = body
		CurrentState = States.Chasing

func BodyEnteredAttackZone(body : Node2D):
	if(CurrentState != States.Chasing):
		return
	if(body.is_in_group("player")):
		CurrentState = States.AttackWinding
		istargetinattackrange = true

func BodyExitedAttackZone(body : Node2D):
	if(body.is_in_group("player")):
		istargetinattackrange = false

func ChangeDirection(NewDirection : int):
	WalkDirection = NewDirection
	if(NewDirection<0):
		sprite.flip_h = false
		sprite.play("walk")
	if(NewDirection>0):
		sprite.flip_h = true
		sprite.play("walk")

func knockback(attacker:Node2D):
	PointAtWhichWasKnockedBack = position
	KnockbackTargetPoint = Vector2(global_position.x - attacker.global_position.x,0).normalized()
	KnockbackTargetPoint *= KnockedbackAmount
	CurrentState = States.Stunned
	await get_tree().create_timer(StaggerDuration).timeout
	if(CurrentState== States.Stunned):
		CurrentState = States.Chasing
