#@tool
@icon("uid://lw455p8jq31p")
class_name PlayerMelee extends Node2D

var Sprite : Sprite2D
var TimeSinceShot : float = 0
const WhichLayerBlocksBullets : int = 3

@export_category("MELEE ATTACK COMPONENTS")
@export var Attacks : Array[MeleeAttack]
@export var CurrentAttack : MeleeAttack:
	set(value):
		if(value.AttackShouldLastAnimationDurationOverride):
			value.RecoveryTime = 0
			value.WindUpTime = 0
			var animTime : float = 0
			var animaref : AnimatedSprite2D= UnlimitedRulebook.player.anima
			animTime = animaref.sprite_frames.get_frame_count(UnlimitedRulebook.MeleeAnimationDict[value.AttackAnimation])/animaref.sprite_frames.get_animation_speed(UnlimitedRulebook.MeleeAnimationDict[value.AttackAnimation])
			value.AttackTime = animTime
		CurrentAttack = value
var AttackIndex : int = 0

var BaseBodyPosition : Vector2
var Body : Node2D

var AttackSigmaDelta : float = 0
var IsAttacking : bool = false
var IsRecovering : bool = false
var AttackQueued : bool = false
var CanChain : bool = false

@export_category("Data")
@export var TimeBetweenShots : float = 1
@export var Crosshair : PackedScene

func _ready() -> void:
	if(CurrentAttack==null):
		CurrentAttack = Attacks[0]
	Sprite = Sprite2D.new()
	UnlimitedRulebook.playerWeapon = self
	Body = UnlimitedRulebook.player
	SetCrosshairScaleAppropiateToSpread()

func SetCrosshairScaleAppropiateToSpread():
	if(Crosshair):
		var CrosshairNode = Crosshair.instantiate()
		add_child(CrosshairNode)
		CrosshairNode.get_node("Sprite2D").scale = Vector2.ONE #* (HitscanBulletSpread/16)

func _process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		#FirePoint = FirePointHelperGizmo.global_position
		#PivotPoint = PivotPointHelperGizmo.global_position
		#GunPoint = GunPreviewHelperGizmo.global_position
		return
	
	if(!IsAttacking):
		if(CurrentAttack.Hit_Box.monitoring):
			CurrentAttack.Hit_Box.monitoring = false
		TimeSinceShot += delta
	else:
		AttackSigmaDelta += delta
		
		CurrentAttack.BodyAttackPathFollow.progress_ratio = CurrentAttack.BodyPositionInPathOverAttackTime.sample_baked(AttackSigmaDelta)/(CurrentAttack.WindUpTime+CurrentAttack.RecoveryTime+CurrentAttack.AttackTime)
		if(AttackSigmaDelta<CurrentAttack.WindUpTime+CurrentAttack.RecoveryTime+CurrentAttack.AttackTime):
			#Body.global_position = BaseBodyPosition + (Body.dir * BodyAttackPathFollow.position)
			var BodyPos = CurrentAttack.BodyAttackPathFollow.position
			if(Body.dir < 0):
				BodyPos.x *= -1
			if(Body.dir > 0):
				BodyPos.x *= 1
			if(!UnlimitedRulebook.player.CheckIfMovingNearWall()):
				Body.global_position = BaseBodyPosition + (BodyPos)
			
		CurrentAttack.Hit_Box.scale = Vector2.ONE * CurrentAttack.ScaleOverAttackTime.sample_baked(AttackSigmaDelta)
		CurrentAttack.MeleeAttackPathFollow.progress_ratio = CurrentAttack.PositionInPathOverAttackTime.sample_baked(AttackSigmaDelta)/(CurrentAttack.WindUpTime+CurrentAttack.RecoveryTime+CurrentAttack.AttackTime)
		CurrentAttack.Hit_Box.global_position = CurrentAttack.MeleeAttackPathFollow.global_position

func Use():
	if(CheckIfCanShoot()):
		if(CanChain):
			CanChain = false
			AttackIndex += 1
			CycleAttack(AttackIndex)
			Shoot()
			return true
		if(IsAttacking):
			AttackQueued = true
			return false
		if(!IsAttacking):
			CurrentAttack = Attacks[AttackIndex]
			Shoot()
			return true
	else:
		#print("SHOOT DISALLOWED")
		return false

func CheckIfCanShoot():
	if(UnlimitedRulebook.player.machine.get_state() in ["talk","cutscene"]):
		return false
	if(CanChain):
		return true
	if(TimeSinceShot>=TimeBetweenShots):
		return true
	#print(CurrentAttack.AttackChainTime)
	#if(AttackIndex!=0 && TimeSinceShot <= CurrentAttack.AttackChainTime && !AttackQueued):
		#return true
	return false

func Shoot():
	print(AttackIndex)
	TimeSinceShot = 0
	AttackSigmaDelta = 0
	BaseBodyPosition = Body.global_position
	IsAttacking = true
	WindUp()

func WindUp():
	get_tree().create_timer(CurrentAttack.WindUpTime).timeout.connect(Attack)

func Attack():
	CurrentAttack.Hit_Box.monitoring = true
	get_tree().create_timer(CurrentAttack.AttackTime).timeout.connect(Recovery)
	#if(AttackIndex<Attacks.size()):
		#CanChainAttack = true
	

func Recovery():
	IsRecovering = true
	CurrentAttack.Hit_Box.monitoring = false

	if(CurrentAttack.RecoveryTime!=0):
		get_tree().create_timer(CurrentAttack.RecoveryTime).timeout.connect(RecoveryFinished)
	else:
		RecoveryFinished()

func RecoveryFinished():
	#if(AttackQueued):
		#Attack()
		#return
	IsRecovering = false
	IsAttacking = false
	AttackSigmaDelta = 0
	

	
	if(AttackIndex+1<Attacks.size()):
		if(AttackQueued):
			AttackIndex += 1
			CycleAttack(AttackIndex)
			UnlimitedRulebook.player.machine.change_state_to("meleeAttack")
			AttackQueued = false
			Shoot()
		else:
			if(CurrentAttack.AttackChainTime>0):
				CanChain = true
				get_tree().create_timer(CurrentAttack.AttackChainTime).timeout.connect(AttackChainTimeout.bind(AttackIndex))
			else:
				CanChain = false
	else:
		CanChain = false
		AttackIndex = 0

func AttackChainTimeout(Whatattackchainindex : int):
	if(Whatattackchainindex == AttackIndex):
		CanChain = false

#AttackIndex += 1
#if(AttackIndex>Attacks.size()-1):
	#AttackIndex = 0
	#CycleAttack(0)
	#AttackQueued = false
	#
	#RecoveryFinished()
#else:
	#CycleAttack(AttackIndex)
	#didChain = true
	#AttackSigmaDelta = 0
	#Shoot()

func CycleAttack(towhichattack : int):
	CurrentAttack = Attacks[towhichattack]
