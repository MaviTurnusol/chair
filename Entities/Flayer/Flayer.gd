extends CharacterBody2D

@export var machine : StateMachine
@onready var marker_2d: Marker2D = $Marker2D
@export var anima : AnimatedSprite2D
@onready var enemyPreps : EnemyPreps = owner.get_node("EnemyPreps")
var dir : float = 1
var CurrentScene : String

var AwarenessOfPlayer : float = 0

func SpotTarget():
	machine.change_state_to("chase")

func HearSound():
	pass

func _ready() -> void:
	UnlimitedRulebook.livestock.append(self)
	print(enemyPreps)
	CurrentScene = owner.get_parent().room.Name

func _process(delta: float) -> void:
	$debugState.text = str(machine.get_state())
	marker_2d.scale.x = dir

func death():
	if UnlimitedRulebook.livestock.has(self):
		UnlimitedRulebook.livestock.erase(self)
		if UnlimitedRulebook.lockedEnemy == self:
			UnlimitedRulebook.UnlockCamera()
			UnlimitedRulebook.lockedEnemy = null
			UnlimitedRulebook.lockedEnemyPosition = Vector2(0, 0)
	queue_free()

#region Knockback
@export var KnockedbackAmount : float = 5
@export var KnockbackDuration : float = 1
const kb_check_offset = Vector2(0,-25)
var KBTween : Tween
func knockback(attacker:Node2D):
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
#endregion
