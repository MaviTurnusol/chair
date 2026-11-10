extends State

func Start():
	#stateOwner.velocity.x = 0
	#stateOwner.set_collisions(false)
	pass

func PhysicsProcess(_delta):
	if Input.get_axis("left", "right") in [1.0, -1.0]:
		stateOwner.dir = Input.get_axis("left", "right")
	stateOwner.move_and_slide()
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, 0.0, 5*_delta)

func End():
	pass
