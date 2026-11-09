extends Node2D
class_name WanderingVagrant

var States
#var CurrentState : State
@onready var Anim : AnimatedSprite2D = $Anim
@onready var boss_core: Node2D = $BossCore
@onready var triped_legs: Legger = $TripedLegs
@export var speed : float = 100
@export var legboost : float = 1
var LegPercent : float = 1

#var PathFindingLayer : TileMapLayer
@onready var enemyPreps : EnemyPreps = owner.get_node("EnemyPreps")

func _ready() -> void:
	UnlimitedRulebook.livestock.append(boss_core)
	print(enemyPreps.spider_paths)
	triped_legs.PathFindingLayer = enemyPreps.spider_paths

func _process(delta: float) -> void:
	if(UnlimitedRulebook.player):
		boss_core.global_position = boss_core.global_position.move_toward(UnlimitedRulebook.player.global_position+Vector2(0,-50),(triped_legs.GetPercentOfLegsAttached()*legboost)*speed*delta)
	#move_and_slide()

var KnockedbackAmount = 200
func knockback(attacker:Node2D):
	var PointAtWhichWasKnockedBack = boss_core.position
	var KnockbackTargetPoint = Vector2(boss_core.global_position.x - attacker.global_position.x,0).normalized()
	KnockbackTargetPoint *= KnockedbackAmount
	#CurrentState = States.Stunned
	var KBTween = get_tree().create_tween()
	KBTween.set_ease(Tween.EASE_OUT)
	KBTween.set_trans(Tween.TRANS_CUBIC)
	KBTween.tween_property(boss_core,"position",PointAtWhichWasKnockedBack+KnockbackTargetPoint,1)
	#await get_tree().create_timer(StaggerDuration).timeout
	#CurrentState = States.Chasing

func death():
	if UnlimitedRulebook.livestock.has(boss_core):
		UnlimitedRulebook.livestock.erase(boss_core)
		if UnlimitedRulebook.lockedEnemy == boss_core:
			UnlimitedRulebook.UnlockCamera()
			UnlimitedRulebook.lockedEnemy = null
			UnlimitedRulebook.lockedEnemyPosition = Vector2(0, 0)
	queue_free()
