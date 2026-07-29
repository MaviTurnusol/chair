@tool
#@icon("res://Guns/Held_SmallGun1.png")
class_name PlayerGun extends Node2D

var Sprite : Sprite2D
var TimeSinceShot : float = 0

@export_category("Data")
@export var GunTexture : Texture2D:
	set(NewText):
		GunTexture = NewText
		ChangeGunPreview()
@export var TimeBetweenShots : float = 1

## PROJECTILE
@export_category("Projectile")
@export var DoShootProjectile : bool:
	set(value):
		DoShootProjectile = value
		notify_property_list_changed()
var Bullet : PackedScene = preload("uid://kelca8sgtdap")
var BulletSpread : float
var BulletAmount : int = 1
var BulletDamage : float = 1
var BulletSpeed : float = 300
var TimeBetweenBullets : float = 0
var BulletWaveAmount : int = 1:
	set(value):
		if(value < 1):
			value = 1
		BulletWaveAmount = value
		notify_property_list_changed()
var TimeBetweenBulletWaves : float = 0.5
var BulletProperties : Array[String]=[
	"Bullet",
	"BulletAmount",
	"BulletSpread",
	"BulletDamage",
	"BulletSpeed",
	"TimeBetweenBullets",
	"BulletWaveAmount",]
##### PROJECTILE OVER

@export_category("Hitscan")
@export var DoShootHitscan : bool:
	set(value):
		DoShootHitscan = value
		notify_property_list_changed()
var HitscanBullet : PackedScene = preload("uid://kelca8sgtdap")
var HitscanTarget : Vector2
var HitscanBulletSpread : Vector2
var HitscanBulletAmount : int = 1
var HitscanBulletDamage : float = 1
var HitscanBulletTime : float = 0.5
#var HitscanBulletSpeed : float = 300
var HitscanTimeBetweenBullets : float = 0
var HitscanBulletWaveAmount : int = 1:
	set(value):
		if(value < 1):
			value = 1
		HitscanBulletWaveAmount = value
		notify_property_list_changed()
var HitscanTimeBetweenBulletWaves : float = 0.5
var HitscanBulletProperties : Array[String]=[
	"HitscanBullet",
	"HitscanBulletAmount",
	"HitscanBulletSpread",
	"HitscanBulletDamage",
	"HitscanBulletTime",
	#"HitscanBulletSpeed",
	"HitscanTimeBetweenBullets",
	"HitscanBulletWaveAmount",]


@export_category("Aesthetic")
@export_group("BulletCasing")
@export var DoThrowBulletCasing : bool = false:
	set(value):
		DoThrowBulletCasing = value
		notify_property_list_changed()
var BulletCasing : PackedScene

@export_group("Recoil")
@export var DoRecoil : bool = false:
	set(value):
		DoRecoil = value
		if(DoSlowMo):
			IsSlowMoDurationDifferentToRecoil = true
		notify_property_list_changed()
## The Amount of time the recoil will be applied for
var recoiltime : float = 0.3
## The Amount of pixels the recoil will displace the hand
var recoilstrength : float = 20

var recoilProperties : Array[String]=[
	"recoiltime",
	"recoilstrength",]

@export_group("Slow Mo")
## Slows
@export var DoSlowMo : bool:
	set(value):
		DoSlowMo = value
		notify_property_list_changed()
var DoSlowMoOnEveryShot : bool = false
var SlowMoStrength : float = 0.5
var IsSlowMoDurationDifferentToRecoil : bool:
	set(value):
		IsSlowMoDurationDifferentToRecoil = value
		notify_property_list_changed()
var SlowMoDuration : float = 0.25

var SlowMoProperties : Array[String]=[
	"DoSlowMoOnEveryShot",
	"SlowMoStrength",]

@export_group("ScreenShake")
## Screen shake amount
@export var DoScreenShake : bool:
	set(value):
		DoScreenShake = value
		notify_property_list_changed()
var DoScreenShakeOnEveryShot : bool = false
var ScreenShakeAmount : float = 0.25

var ScreenShakeProperties : Array[String]=[
	"DoScreenShakeOnEveryShot",
	"ScreenShakeAmount",]

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
	
func _process(delta: float) -> void:
			
	if(Engine.is_editor_hint()):
		FirePoint = FirePointHelperGizmo.global_position
		PivotPoint = PivotPointHelperGizmo.global_position
		GunPoint = GunPreviewHelperGizmo.global_position
		return
	
	TimeSinceShot += delta

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
	else:
		print("Wait More Time Before Shooting Again")

func CheckIfCanShoot():
	if(TimeSinceShot>=TimeBetweenShots):
		return true
	else:
		return false

func Shoot():
	if(DoShootProjectile):
		ShootBullet()
	if(DoShootHitscan):
		ShootHitscan()
	TimeSinceShot = 0

func ShootBullet():
	for wave in range(0,BulletWaveAmount):
		var hasfiredonce : bool = false
		for i in range(0,BulletAmount):
			
			FireBullet()
			
			#Casing
			if(DoThrowBulletCasing):
				Casing()
			
			#Recoil
			if(!hasfiredonce): #Useful for shotgun style
				if(DoRecoil):
					Recoil()
				if(DoSlowMo):
					SlowMo()
				if(DoScreenShake):
					#Effects.emit_signal("Screenshake",ScreenShakeAmount)
					print("emit screenshake")
				hasfiredonce = true
			elif(TimeBetweenBullets!=0): #Useful for burst style
				if(DoRecoil):
					Recoil()
				if(DoSlowMo && DoSlowMoOnEveryShot):
					SlowMo()
				if(DoScreenShake && DoScreenShakeOnEveryShot):
					#Effects.emit_signal("Screenshake",ScreenShakeAmount)
					print("emit screenshake")
			
			if(TimeBetweenBullets!=0):
				await get_tree().create_timer(TimeBetweenBullets).timeout
		await get_tree().create_timer(TimeBetweenBulletWaves).timeout

func FireBullet():
	var NewBullet : Area2D = Bullet.instantiate()
	NewBullet.global_position = to_global(FirePoint)
	UnlimitedRulebook.currentScene.add_child(NewBullet)
	NewBullet.global_rotation = global_rotation
	NewBullet.linear_velocity = Vector2.RIGHT.rotated(global_rotation+deg_to_rad(randf_range(-BulletSpread,BulletSpread))) * BulletSpeed
	NewBullet.Damage = BulletDamage

func ShootHitscan():
	for wave in range(0,HitscanBulletWaveAmount):
		var hasfiredonce : bool = false
		for i in range(0,HitscanBulletAmount):
			
			FireHitscan()
			
			#Casing
			if(DoThrowBulletCasing):
				Casing()
			
			#Recoil
			if(!hasfiredonce): #Useful for shotgun style
				if(DoRecoil):
					Recoil()
				if(DoSlowMo):
					SlowMo()
				if(DoScreenShake):
					#Effects.emit_signal("Screenshake",ScreenShakeAmount)
					print("emit screenshake")
				hasfiredonce = true
			elif(HitscanTimeBetweenBullets!=0): #Useful for burst style
				if(DoRecoil):
					Recoil()
				if(DoSlowMo && DoSlowMoOnEveryShot):
					SlowMo()
				if(DoScreenShake && DoScreenShakeOnEveryShot):
					#Effects.emit_signal("Screenshake",ScreenShakeAmount)
					print("emit screenshake")
			
			if(HitscanTimeBetweenBullets!=0):
				await get_tree().create_timer(HitscanTimeBetweenBullets).timeout
		await get_tree().create_timer(HitscanTimeBetweenBulletWaves).timeout

func FireHitscan():
	var NewHitLine : Line2D = Line2D.new()
	UnlimitedRulebook.currentScene.add_child(NewHitLine)
	HitscanTarget = get_global_mouse_position()
	var SpreadTarget = HitscanTarget + Vector2(randf_range(-HitscanBulletSpread.x,HitscanBulletSpread.x),randf_range(-HitscanBulletSpread.y,HitscanBulletSpread.y))
	NewHitLine.add_point(to_global(FirePoint))
	NewHitLine.add_point(SpreadTarget)
	
	var NewBullet : Area2D = null
	var NewRayCast : RayCast2D = RayCast2D.new()
	UnlimitedRulebook.currentScene.add_child(NewRayCast)
	NewRayCast.global_position = to_global(FirePoint)
	#NewRayCast.target_position = to_local(SpreadTarget)
	NewRayCast.target_position = get_global_mouse_position() - global_position
	NewRayCast.hit_from_inside = true
	var terrainlayer : int = (1 << 5 - 1) 
	NewRayCast.collision_mask = terrainlayer ## TERRAIN LAYER
	
	NewRayCast.force_raycast_update()
	if(NewRayCast.is_colliding()):
		print("CantShoot through walls")
		NewHitLine.points[1] = NewHitLine.to_local(NewRayCast.get_collision_point())
	else:
		NewBullet = Bullet.instantiate()
		NewBullet.global_position = SpreadTarget
		UnlimitedRulebook.currentScene.add_child(NewBullet)
		NewBullet.Damage = BulletDamage
	
	await get_tree().create_timer(HitscanBulletTime).timeout
	NewHitLine.queue_free()
	if(NewBullet!=null):
		NewBullet.queue_free()


func Casing():
	var NewBulletCasing : RigidBody2D = BulletCasing.instantiate()
	NewBulletCasing.global_position = global_position
	get_tree().root.add_child(NewBulletCasing)
	NewBulletCasing.linear_velocity = Vector2.UP * randf_range(250,500)

func Recoil():
	get_parent().get_parent().get_parent().RecoilArmControlLost = true
	var target = get_parent().get_parent().get_parent().ReachingHandTarget.global_position - Vector2.RIGHT.rotated(global_rotation) * recoilstrength
	var recoiltween : Tween = get_tree().create_tween()
	recoiltween.set_ease(Tween.EASE_OUT)
	recoiltween.set_trans(Tween.TRANS_BACK)
	recoiltween.tween_property(get_parent().get_parent().get_parent().ReachingHandTarget,"global_position",target,recoiltime/2)
	await get_tree().create_timer(recoiltime).timeout
	get_parent().get_parent().get_parent().RecoilArmControlLost = false

func SlowMo():
	if(SlowMoDuration==0):
		return
	Engine.time_scale = SlowMoStrength # 0.5 default
	var slowtween : Tween = get_tree().create_tween()
	slowtween.set_ease(Tween.EASE_OUT)
	slowtween.set_trans(Tween.TRANS_BACK)
	if(IsSlowMoDurationDifferentToRecoil):
		slowtween.tween_property(Engine,"time_scale",1,SlowMoDuration)
	else:
		slowtween.tween_property(Engine,"time_scale",1,recoiltime)

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
	for i in BulletProperties:
		if(property.name == i && !DoShootProjectile):
			property.usage |= PROPERTY_USAGE_NONE
		if(property.name == i && DoShootProjectile):
			property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	
	if(property.name == "TimeBetweenBulletWaves"):
		if(DoShootProjectile):
			if(BulletWaveAmount == 1):
				property.usage |=  PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_READ_ONLY
			else:
				property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
		else:
			property.usage |= PROPERTY_USAGE_NONE
	
	if(property.name == "HitscanTimeBetweenBulletWaves"):
		if(DoShootHitscan):
			if(HitscanBulletWaveAmount == 1):
				property.usage |=  PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_READ_ONLY
			else:
				property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
		else:
			property.usage |= PROPERTY_USAGE_NONE
	
	
	for i in HitscanBulletProperties:
		if(property.name == i && !DoShootHitscan):
			property.usage |= PROPERTY_USAGE_NONE
		if(property.name == i && DoShootHitscan):
			property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	
	for i in recoilProperties:
		if(property.name == i && !DoRecoil):
			property.usage |= PROPERTY_USAGE_NONE
		if(property.name == i && DoRecoil):
			property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	
	for i in ScreenShakeProperties:
		if(property.name == i && !DoScreenShake):
			property.usage |= PROPERTY_USAGE_NONE
		if(property.name == i && DoScreenShake):
			property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	
	if(property.name == "BulletCasing"):
		if(DoThrowBulletCasing):
			property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
		else:
			property.usage |= PROPERTY_USAGE_NONE
	
	for i in SlowMoProperties:
		if(property.name == i && !DoSlowMo):
			property.usage |= PROPERTY_USAGE_NONE
		if(property.name == i && DoSlowMo):
			property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
	
	if(DoSlowMo):
		if(!DoRecoil):
			if(property.name == "SlowMoDuration"):
				property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
			if(property.name == "IsSlowMoDurationDifferentToRecoil"):
				property.usage |=  PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_READ_ONLY
		else:
			if(property.name == "IsSlowMoDurationDifferentToRecoil"):
				property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
			if(IsSlowMoDurationDifferentToRecoil):
				if(property.name == "SlowMoDuration"):
					property.usage |= PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_STORAGE
#endregion
