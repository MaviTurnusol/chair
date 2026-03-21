extends State

func Start():
	if Input.is_action_pressed("right"):
		stateOwner.velocity.x = 320
		stateOwner.flip("right")
	elif Input.is_action_pressed("left"):
		stateOwner.velocity.x = -320
		stateOwner.flip("left")
	else:
		stateOwner.velocity.x = stateOwner.dir * 320
	
	stateOwner.set_collisions(false)

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	if stateOwner.anima.animation == animName:
		if stateOwner.anima.frame >= 7:
			stateOwner.velocity.x = lerp(stateOwner.velocity.x, 0.0, 0.1)
			stateOwner.set_collisions(true)
