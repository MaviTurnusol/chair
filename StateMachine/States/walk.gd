extends State

func PhysicsProcess(_delta):
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, stateOwner.dir*stateOwner.speed, 0.1)
	if abs(stateOwner.velocity.x) <= stateOwner.speed * 1.35:
		stateOwner.anima.play(animName)
	stateOwner.move_and_slide()
