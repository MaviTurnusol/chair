extends Area2D

var active = true
@export var father : Node2D
@export var healthComp : Node

func damage(attack, attacker):
	if !active:
		return
	#UnlimitedRulebook.frameFreeze(0.05, 0.2)
	if father.has_method("knockback"):
		father.knockback(attacker)
	if healthComp:
		healthComp.damage(attack)
		if father:
			if father.has_node("hitflashPlayer"):
				father.get_node("hitflashPlayer").play("hitflash")
	if not is_inside_tree():return
	set_deferred("monitorable", false)
	if not is_inside_tree():return
	await get_tree().process_frame
	if not is_inside_tree():return
	await get_tree().process_frame
	set_deferred("monitorable", true)
