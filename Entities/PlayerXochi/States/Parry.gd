extends State

func Start():
	#stateOwner.velocity.x = 0
	#stateOwner.set_collisions(false)
	pass

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, 0.0, 5*_delta)

func End():
	pass
