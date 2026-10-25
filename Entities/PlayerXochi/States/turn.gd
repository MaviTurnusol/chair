extends State

func PhysicsProcess(_delta):
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, -stateOwner.dir*stateOwner.speed, 0.1)
	stateOwner.move_and_slide()

func End():
	stateOwner.dir = -stateOwner.dir
