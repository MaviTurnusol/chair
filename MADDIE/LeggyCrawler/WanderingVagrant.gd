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

@export var PathFindingLayer : TileMapLayer

func _process(delta: float) -> void:
	if(UnlimitedRulebook.player):
		boss_core.global_position = boss_core.global_position.move_toward(UnlimitedRulebook.player.global_position+Vector2(0,-50),(triped_legs.GetPercentOfLegsAttached()*legboost)*speed*delta)
	#move_and_slide()
