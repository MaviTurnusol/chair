extends Node2D

var isHoldingGun : bool = true

@export var Bullet : PackedScene
@export var BulletCasing : PackedScene
@export var BulletSpeed : float = 300
@onready var FirePoint = $FirePoint
var timesinceshot : float = 0
@export var TimeBetweenShots : float = 1
@onready var ParticleMuzzleFlash : GPUParticles2D = $ParticleMuzzleFlash

@export var recoiltime : float = 0.3
@export var recoilstrength : float = 20

func _process(delta: float) -> void:
	timesinceshot += delta

func Shoot():
	if(timesinceshot<TimeBetweenShots):
		return
	ShootBullet()
	Recoil()
	Casing()
	$GunFire.play()

func Casing():
	var NewBullet : RigidBody2D = BulletCasing.instantiate()
	NewBullet.global_position = global_position
	get_parent().get_parent().add_child(NewBullet)
	NewBullet.linear_velocity = Vector2.UP * randf_range(250,500) #Vector2.RIGHT.rotated(FirePoint.global_rotation) * BulletSpeed

func ShootBullet():
	var NewBullet : RigidBody2D = Bullet.instantiate()
	NewBullet.global_position = FirePoint.global_position
	get_parent().get_parent().add_child(NewBullet)
	NewBullet.linear_velocity =  Vector2.RIGHT.rotated(FirePoint.global_rotation) * BulletSpeed
	timesinceshot = 0

func Recoil():
	get_parent().RecoilArmControlLost = true
	var target = get_parent().ReachingHandTarget.global_position - Vector2.RIGHT.rotated(FirePoint.global_rotation) * recoilstrength
	var recoiltween : Tween = get_tree().create_tween()
	recoiltween.set_ease(Tween.EASE_OUT)
	recoiltween.set_trans(Tween.TRANS_BACK)
	ParticleMuzzleFlash.emitting = true
	Effects.emit_signal("Screenshake",0.25)
	Engine.time_scale = 0.5
	recoiltween.tween_property(get_parent().ReachingHandTarget,"global_position",target,recoiltime/2)
	recoiltween.tween_property(Engine,"time_scale",1,recoiltime)
	await get_tree().create_timer(recoiltime).timeout
	get_parent().RecoilArmControlLost = false
