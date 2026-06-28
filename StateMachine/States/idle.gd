extends State

func PhysicsProcess(_delta):
	if abs(stateOwner.velocity.x) < 100:
		stateOwner.anima.play(animName)
	stateOwner.move_and_slide()
