extends Node2D

#STATES
var CurrentState : States = States.Idle:
	set(value):
		StateChanged(CurrentState,value)
		CurrentState = value
enum States{
	Idle,
	Chasing,
	Stunned,
}

@export var ChaseSpeed : float = 5
@onready var aggro_zone: Area2D = $AggroZone
var AggroTarget : Node2D

var WalkDirection : int = 0

#Knockback
@export var KnockedbackAmount : float = 5
var KnockbackTargetPoint : Vector2
var PointAtWhichWasKnockedBack : Vector2
@export var StaggerDuration : float = 1

func StateChanged(_OldState : States,NewState : States):
	match NewState:
		pass

func death():
	queue_free()

func _ready() -> void:
	aggro_zone.body_entered.connect(BodyEnteredAggroZone)

func _process(delta: float) -> void:
	if(CurrentState == States.Chasing):
		if(AggroTarget):
			if(AggroTarget.global_position.x<global_position.x):
				if(WalkDirection!=-1):
					ChangeDirection(-1)
			if(AggroTarget.global_position.x>global_position.x):
				if(WalkDirection!=1):
					ChangeDirection(1)
		position.x += ChaseSpeed*delta*WalkDirection
	
	if(CurrentState == States.Stunned):
		position = position.move_toward(PointAtWhichWasKnockedBack+KnockbackTargetPoint,KnockedbackAmount/StaggerDuration*delta)

func BodyEnteredAggroZone(body : Node2D):
	if(CurrentState != States.Idle):
		return
	if(body.is_in_group("player")):
		AggroTarget = body
		CurrentState = States.Chasing

func ChangeDirection(NewDirection : int):
	WalkDirection = NewDirection
	if(NewDirection<0):
		pass

func knockback(attacker:Node2D):
	PointAtWhichWasKnockedBack = position
	KnockbackTargetPoint = Vector2(global_position.x - attacker.global_position.x,0).normalized()
	KnockbackTargetPoint *= KnockedbackAmount
	CurrentState = States.Stunned
	await get_tree().create_timer(StaggerDuration).timeout
	CurrentState = States.Chasing
