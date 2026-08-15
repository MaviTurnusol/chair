@tool
#@icon("res://Guns/Held_SmallGun1.png")
class_name PlayerMelee extends Node2D

var Sprite : Sprite2D
var TimeSinceShot : float = 0

const WhichLayerBlocksBullets : int = 3

@export_category("MELEE ATTACK COMPONENTS")
@export var WindUpTime : float = 0.5
@export var AttackTime : float = 1.0
@export var RecoveryTime : float = 0.5

@export var Hit_Box : Area2D

@export var MeleeAttackPath : Path2D
@export var MeleeAttackPathFollow : PathFollow2D
@export var PositionInPathOverAttackTime : Curve
@export var ScaleOverAttackTime : Curve

var BaseBodyPosition : Vector2
var Body : Node2D
@export var BodyAttackPath : Path2D
@export var BodyAttackPathFollow : PathFollow2D
@export var BodyPositionInPathOverAttackTime : Curve

var AttackSigmaDelta : float = 0
var IsAttacking : bool = false

@export_category("Data")
@export var GunTexture : Texture2D:
	set(NewText):
		GunTexture = NewText
		ChangeGunPreview()
@export var TimeBetweenShots : float = 1
@export var Crosshair : PackedScene

@export_category("Key Points")
var PivotPoint : Vector2:
	set(NewValue):
		PivotPoint = NewValue
		if(Engine.is_editor_hint()):
			if(PivotPointHelperGizmo!=null):
				PivotPointHelperGizmo.Pos = NewValue

var FirePoint : Vector2:
	set(NewValue):
		FirePoint = NewValue
		if(Engine.is_editor_hint()):
			if(FirePointHelperGizmo!=null):
				FirePointHelperGizmo.Pos = NewValue

var GunPoint : Vector2:
	set(NewValue):
		GunPoint = NewValue
		if(Engine.is_editor_hint()):
			if(GunPreviewHelperGizmo!=null):
				GunPreviewHelperGizmo.Pos = NewValue

func _ready() -> void:
	if(Engine.is_editor_hint()):
		CreateEditorGizmos()
	else:
		if(GunPreviewSprite!=null):
			GunPreviewSprite.queue_free()
		ConstructGun()
	UnlimitedRulebook.playerWeapon = self
	SetCrosshairScaleAppropiateToSpread()

func SetCrosshairScaleAppropiateToSpread():
	if(Crosshair):
		var CrosshairNode = Crosshair.instantiate()
		add_child(CrosshairNode)
		CrosshairNode.get_node("Sprite2D").scale = Vector2.ONE #* (HitscanBulletSpread/16)

func _process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		FirePoint = FirePointHelperGizmo.global_position
		PivotPoint = PivotPointHelperGizmo.global_position
		GunPoint = GunPreviewHelperGizmo.global_position
		return
	
	if(!IsAttacking):
		if(Hit_Box.monitoring):
			Hit_Box.monitoring = false
		TimeSinceShot += delta
	else:
		AttackSigmaDelta += delta
		
		BodyAttackPathFollow.progress_ratio = BodyPositionInPathOverAttackTime.sample_baked(AttackSigmaDelta)/(WindUpTime+RecoveryTime+AttackTime)
		if(AttackSigmaDelta<WindUpTime+RecoveryTime+AttackTime):
			#Body.global_position = BaseBodyPosition + (Body.dir * BodyAttackPathFollow.position)
			var BodyPos = BodyAttackPathFollow.position
			if(Body.dir < 0):
				BodyPos.x *= -1
			if(Body.dir > 0):
				BodyPos.x *= 1
			Body.global_position = BaseBodyPosition + (BodyPos)
	
		Hit_Box.scale = Vector2.ONE * ScaleOverAttackTime.sample_baked(AttackSigmaDelta)
		MeleeAttackPathFollow.progress_ratio = PositionInPathOverAttackTime.sample_baked(AttackSigmaDelta)/(WindUpTime+RecoveryTime+AttackTime)
		Hit_Box.global_position = MeleeAttackPathFollow.global_position

## Before this function is called the sprite is an editor-only preview
func ConstructGun():
	Sprite = Sprite2D.new()
	add_child(Sprite)
	Sprite.offset = PivotPoint
	Sprite.position = GunPoint
	Sprite.texture = GunTexture

func Use():
	if(CheckIfCanShoot()):
		Shoot()
		UnlimitedRulebook.player.melee_helper.Attack()
	else:
		print("SHOOT DISALLOWED")
		#print("Wait More Time Before Shooting Again")

func CheckIfCanShoot():
	if(UnlimitedRulebook.player.machine.get_state() in ["talk","cutscene"]):
		return false
	if(TimeSinceShot>=TimeBetweenShots):
		return true
	else:
		return false

func Shoot():
	TimeSinceShot = 0
	BaseBodyPosition = Body.global_position
	IsAttacking = true
	WindUp()

func WindUp():
	get_tree().create_timer(WindUpTime).timeout.connect(Attack)

func Attack():
	Hit_Box.monitoring = true
	get_tree().create_timer(AttackTime).timeout.connect(Recovery)

func Recovery():
	get_tree().create_timer(RecoveryTime).timeout.connect(RecoveryFinished)

func RecoveryFinished():
	IsAttacking = false
	AttackSigmaDelta = 0
	#Body.global_position = BaseBodyPosition + BodyAttackPath.curve.sample_baked(0.99)

#region Editor Only
#Editor Only
@export var FirePointHelperGizmo : HelperGizmo
@export var PivotPointHelperGizmo : HelperGizmo
@export var GunPreviewHelperGizmo : HelperGizmo
@export var GunPreviewSprite : Sprite2D

func CreateEditorGizmos():
	if(!has_node("Fire Point")):
		FirePointHelperGizmo = HelperGizmo.new("Fire Point")
		add_child(FirePointHelperGizmo)
		FirePointHelperGizmo.Pos = FirePoint
	else:
		FirePointHelperGizmo = get_node("Fire Point") as HelperGizmo
		FirePoint = FirePointHelperGizmo.global_position
	
	if(!has_node("Pivot Point")):
		PivotPointHelperGizmo = HelperGizmo.new("Pivot Point")
		add_child(PivotPointHelperGizmo)
		PivotPointHelperGizmo.Pos = PivotPoint
	else:
		PivotPointHelperGizmo = get_node("Pivot Point") as HelperGizmo
		PivotPoint = PivotPointHelperGizmo.global_position
	
	if(!has_node("Pivot Point/Gun Preview")):
		GunPreviewHelperGizmo = HelperGizmo.new("Gun Preview")
		if(GunTexture!=null):
			ChangeGunPreview()
		PivotPointHelperGizmo.add_child(GunPreviewHelperGizmo)
		GunPreviewHelperGizmo.Pos = PivotPoint
	else:
		GunPreviewHelperGizmo = get_node("Pivot Point/Gun Preview") as HelperGizmo
		GunPoint = GunPreviewHelperGizmo.global_position
		if(GunTexture!=null):
			ChangeGunPreview()

func ChangeGunPreview():
	if(Engine.is_editor_hint()):
		if(GunPreviewSprite==null):
			GunPreviewSprite = Sprite2D.new()
			GunPreviewHelperGizmo.add_child(GunPreviewSprite)
			GunPreviewSprite.position = Vector2.ZERO
		GunPreviewSprite.texture = GunTexture
	else:
		if(GunPreviewSprite!=null):
			GunPreviewSprite.queue_free()
			GunPreviewSprite=null

###FOR DROPDOWN-CHECKBOXES
func _validate_property(property: Dictionary) -> void:
	pass
	#for i in BulletProperties:
		#if(property.name == i && !DoShootProjectile):
			#property.usage |= PROPERTY_USAGE_NONE
		#if(property.name == i && DoShootProjectile):
			#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	#
	#if(property.name == "TimeBetweenBulletWaves"):
		#if(DoShootProjectile):
			#if(BulletWaveAmount == 1):
				#property.usage |=  PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_READ_ONLY
			#else:
				#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
		#else:
			#property.usage |= PROPERTY_USAGE_NONE
	#
	#if(property.name == "HitscanTimeBetweenBulletWaves"):
		#if(DoShootHitscan):
			#if(HitscanBulletWaveAmount == 1):
				#property.usage |=  PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_READ_ONLY
			#else:
				#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
		#else:
			#property.usage |= PROPERTY_USAGE_NONE
	#
	#for i in HitscanBulletProperties:
		#if(property.name == i && !DoShootHitscan):
			#property.usage |= PROPERTY_USAGE_NONE
		#if(property.name == i && DoShootHitscan):
			#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	#
	#for i in recoilProperties:
		#if(property.name == i && !DoRecoil):
			#property.usage |= PROPERTY_USAGE_NONE
		#if(property.name == i && DoRecoil):
			#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	#
	#for i in ScreenShakeProperties:
		#if(property.name == i && !DoScreenShake):
			#property.usage |= PROPERTY_USAGE_NONE
		#if(property.name == i && DoScreenShake):
			#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	#
	#if(property.name == "BulletCasingShootStrength"):
		#if(DoThrowBulletCasing):
			#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
		#else:
			#property.usage |= PROPERTY_USAGE_NONE
	#if(property.name == "BulletCasingShootDirection"):
		#if(DoThrowBulletCasing):
			#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
		#else:
			#property.usage |= PROPERTY_USAGE_NONE
	#
	#if(property.name == "BulletCasing"):
		#if(DoThrowBulletCasing):
			#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
		#else:
			#property.usage |= PROPERTY_USAGE_NONE
	#
	#for i in SlowMoProperties:
		#if(property.name == i && !DoSlowMo):
			#property.usage |= PROPERTY_USAGE_NONE
		#if(property.name == i && DoSlowMo):
			#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	#
	#if(DoSlowMo):
		#if(!DoRecoil):
			#if(property.name == "SlowMoDuration"):
				#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
			#if(property.name == "IsSlowMoDurationDifferentToRecoil"):
				#property.usage |=  PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_READ_ONLY
		#else:
			#if(property.name == "IsSlowMoDurationDifferentToRecoil"):
				#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
			#if(IsSlowMoDurationDifferentToRecoil):
				#if(property.name == "SlowMoDuration"):
					#property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	#
	#if(DoShootHitscan && property.name == "HitscanAesthetic"):
		#property.usage = PROPERTY_USAGE_SUBGROUP + PROPERTY_USAGE_STORAGE
	#if(property.name == "HitscanLineEasing")  && DoShootHitscan:
		#property.usage += PROPERTY_USAGE_CLASS_IS_ENUM + PROPERTY_USAGE_STORAGE +  PROPERTY_USAGE_EDITOR 
		#property.hint = PropertyHint.PROPERTY_HINT_ENUM
		#var EaseString : String
		#EaseString = "EASE_IN:0," + "EASE_OUT:1," + "EASE_IN_OUT:2," + "EASE_OUT_IN:3"
		#property.hint_string = EaseString
	#if(property.name == "HitscanLineTrans") && DoShootHitscan:
		#property.usage += PROPERTY_USAGE_CLASS_IS_ENUM + PROPERTY_USAGE_STORAGE +  PROPERTY_USAGE_EDITOR 
		#property.hint = PropertyHint.PROPERTY_HINT_ENUM
		#var TransString : String
		#TransString = "TRANS_LINEAR:0,"+"TRANS_SINE:1,"+"TRANS_QUINT:2,"+"TRANS_QUART:3,"+"TRANS_QUAD:4,"+"TRANS_EXPO:5,"+"TRANS_ELASTIC:6,"+"TRANS_CUBIC:7,"+"TRANS_CIRC:8,"+"TRANS_BOUNCE: = 9,"+"TRANS_BACK:10,"+"TRANS_SPRING:11"
		#property.hint_string = TransString
	

#endregion
