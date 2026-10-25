extends State

func PhysicsProcess(_delta):
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, stateOwner.dir*stateOwner.speed*1.6, 0.1)
	stateOwner.anima.play(animName)
	stateOwner.move_and_slide()
