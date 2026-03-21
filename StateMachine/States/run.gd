extends State

func PhysicsProcess(_delta):
	stateOwner.anima.play(animName)
	stateOwner.move_and_slide()
