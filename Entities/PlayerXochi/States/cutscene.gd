extends State

var actionable

func Process(_delta):
	var talking_point = actionable.talking_point
	var dir = -sign(stateOwner.global_position.x - talking_point.x)
	if !abs(stateOwner.global_position.x - talking_point.x) < 5:
		stateOwner.get_node("Marker2D").scale.x = dir
		stateOwner.velocity.x = lerp(stateOwner.velocity.x, stateOwner.speed*dir, 0.5)
		if stateOwner.is_on_floor():
			stateOwner.anima.play("walk")
	else:
		var actionable_dir = -sign(stateOwner.global_position.x - actionable.global_position.x)
		stateOwner.get_node("Marker2D").scale.x = actionable_dir
		UnlimitedRulebook.got_on_the_talking_point.emit()
		stateOwner.anima.play("idle")
		stateOwner.velocity.x = lerp(stateOwner.velocity.x, 0.0, 0.5)
		machine.change_state_to("talk")
	stateOwner.move_and_slide()
	pass
