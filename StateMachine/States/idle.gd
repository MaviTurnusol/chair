extends State

func PhysicsProcess(_delta):
	if abs(stateOwner.velocity.x) < 60:
		stateOwner.anima.play(animName)
	stateOwner.move_and_slide()
