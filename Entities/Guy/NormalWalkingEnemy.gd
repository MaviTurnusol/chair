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
var KBTween : Tween
func StateChanged(_OldState : States,NewState : States):
	match NewState:
		pass

func death():
	if UnlimitedRulebook.livestock.has(self):
		UnlimitedRulebook.livestock.erase(self)
		if UnlimitedRulebook.lockedEnemy == self:
			UnlimitedRulebook.UnlockCamera()
			UnlimitedRulebook.lockedEnemy = null
			UnlimitedRulebook.lockedEnemyPosition = Vector2(0, 0)
	queue_free()

func _ready() -> void:
	UnlimitedRulebook.livestock.append(self)
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
	
	if(CurrentState != States.Stunned):
		if(KBTween):
			KBTween.kill()
		#position = position.move_toward(PointAtWhichWasKnockedBack+KnockbackTargetPoint,KnockedbackAmount/StaggerDuration*delta)

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
	KBTween = get_tree().create_tween()
	KBTween.set_ease(Tween.EASE_OUT)
	KBTween.set_trans(Tween.TRANS_CUBIC)
	KBTween.tween_property(self,"position",PointAtWhichWasKnockedBack+KnockbackTargetPoint,StaggerDuration)
	await get_tree().create_timer(StaggerDuration).timeout
	CurrentState = States.Chasing
