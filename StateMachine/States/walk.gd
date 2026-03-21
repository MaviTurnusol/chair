extends State

func PhysicsProcess(_delta):
	if abs(stateOwner.velocity.x) <= stateOwner.speed * 1.35:
		stateOwner.anima.play(animName)
	stateOwner.move_and_slide()
