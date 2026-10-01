extends Node2D
class_name MeleeAttack

@export var Hit_Box : Area2D

@export var WindUpTime : float = 0.5
@export var AttackTime : float = 1.0
@export var RecoveryTime : float = 0.5
@export var AttackChainTime : float = 0.5

@export var AttackAnimation : UnlimitedRulebook.MeleeAnimation

@export var PositionInPathOverAttackTime : Curve
@export var ScaleOverAttackTime : Curve
@export var MeleeAttackPath : Path2D
@export var MeleeAttackPathFollow : PathFollow2D

@export var BodyAttackPath : Path2D
@export var BodyAttackPathFollow : PathFollow2D
@export var BodyPositionInPathOverAttackTime : Curve
